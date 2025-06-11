# variables.tf in terraform/deployment/

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1" # Keep the same region unless intended
}

variable "cluster_name" {
  description = "The name for the EKS cluster."
  # --- CHANGE THIS ---
  default     = "deployment-cluster"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  # --- CHANGE THIS TO AVOID OVERLAPPING WITH THE DEV VPC ---
  default     = "10.1.0.0/16"
}

variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets."
  # --- CHANGE THIS TO MATCH THE NEW VPC CIDR ---
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}
