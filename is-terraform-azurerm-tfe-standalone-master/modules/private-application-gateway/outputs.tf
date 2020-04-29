output "application_gateway_id" {
  description = "Application Gateway id."
  value       = azurerm_application_gateway.appgateway.id
}

output "private_ip" {
  description = "Private IP of the Application Gateway."
  value       = azurerm_application_gateway.appgateway.frontend_ip_configuration.0.private_ip_address
}

output "health_probe_id" {
  description = "Health Probe Id for the health checks on the load balancer."
  value       = azurerm_application_gateway.appgateway.probe[0].id
}

output "backend_address_pool_id" {
  description = "Backend addresss pool, for use with the VM Scale Set."
  value       = azurerm_application_gateway.appgateway.backend_address_pool.0.id
}
