# outputs.tf in terraform/deployment/

output "cluster_name" {
  description = "The name of the Deployment EKS cluster."
  value       = aws_eks_cluster.dev_cluster.name # Assumes the resource is named 'dev_cluster' in main.tf
}

output "cluster_endpoint" {
  description = "The endpoint for the Deployment EKS cluster's API server."
  value       = aws_eks_cluster.dev_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the Deployment EKS cluster."
  value       = aws_eks_cluster.dev_cluster.certificate_authority[0].data
}

output "node_group_name" {
  description = "The name of the Deployment EKS node group."
  value       = aws_eks_node_group.dev_node_group.node_group_name
}
