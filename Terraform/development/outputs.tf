# outputs.tf in terraform/development/

output "cluster_name" {
  description = "The name of the Development EKS cluster."
  value       = aws_eks_cluster.dev_cluster.name
}

output "cluster_endpoint" {
  description = "The endpoint for the Development EKS cluster's API server."
  value       = aws_eks_cluster.dev_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the Development EKS cluster."
  value       = aws_eks_cluster.dev_cluster.certificate_authority[0].data
}

output "node_group_name" {
  description = "The name of the Development EKS node group."
  value       = aws_eks_node_group.dev_node_group.node_group_name
}
