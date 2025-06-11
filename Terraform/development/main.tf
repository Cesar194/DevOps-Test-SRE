# Corrected and complete main.tf for the 'development' environment

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

# 1. Create a VPC for the cluster
resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr

  # EKS requires DNS hostnames and support to be enabled
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# 2. Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# 3. Create a Route Table for the VPC
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.dev_vpc.id

  # Create a route that directs internet-bound traffic to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

# 4. Create Subnets
resource "aws_subnet" "dev_subnet" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = tolist(data.aws_availability_zones.available.names)[count.index]

  # This setting is crucial for nodes to join the cluster from a public subnet
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.cluster_name}-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# 5. Associate the Route Table with each Subnet
resource "aws_route_table_association" "a" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.dev_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}


# 6. Create an IAM role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# 7. Create the EKS Cluster resource
resource "aws_eks_cluster" "dev_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = aws_subnet.dev_subnet[*].id
  }
  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# 8. Create an IAM role for the Node Group workers
resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_policy_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_policy_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# 9. Create the Node Group
resource "aws_eks_node_group" "dev_node_group" {
  cluster_name    = aws_eks_cluster.dev_cluster.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.dev_subnet[*].id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  depends_on = [
    aws_iam_role_policy_attachment.node_policy_worker,
    aws_iam_role_policy_attachment.node_policy_cni,
    aws_iam_role_policy_attachment.node_policy_ecr,
  ]
}
