# variables.tf

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1" # Or your preferred region
}

variable "cluster_name" {
  description = "The name for the EKS cluster."
  default     = "development-cluster"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
