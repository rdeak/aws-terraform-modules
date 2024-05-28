output "service_url" {
  value = aws_lightsail_container_service.main.url
  description = "Deployed service URL"
}
