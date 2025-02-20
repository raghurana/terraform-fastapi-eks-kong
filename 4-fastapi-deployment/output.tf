# Let's output the details after fastapi deployment:

output "deployment" {
  value = kubernetes_deployment.fastapi.metadata.0.name
}

output "service" {
  value = kubernetes_service.fastapi.metadata.0.name
}

output "service_ip" {
  value = kubernetes_service.fastapi.spec.0.cluster_ip
}


output "service_type" {
  value = kubernetes_service.fastapi.spec.0.type
}


