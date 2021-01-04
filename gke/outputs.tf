output "cluster_name" {
  value       = google_container_cluster.k8s_cluster.name
  description = "Name of the created GKE cluster"
}

output "cluster_zone" {
  value       = google_container_cluster.k8s_cluster.location
  description = "Location the GKE cluster was created in"
}

output "cluster_endpoint" {
  value       = google_container_cluster.k8s_cluster.endpoint
  description = "Management GKE cluster endpoint"
}

output "cluster_kubeconfig" {
  value       = base64encode(data.template_file.kubeconfig.rendered)
  description = "Base64 encoded version of cluster kubeconfig"
}