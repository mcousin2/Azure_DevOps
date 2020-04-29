output "application_gateway_id" {
  description = "Application Gateway id."
  value       = azurerm_application_gateway.appgateway.id
}

output "load_balancer_domain_label" {
  description = "Public FQDN of the Application Gateway. DNS provided by Azure."
  value       = azurerm_public_ip.appgateway.fqdn
}

output "public_ip" {
  description = "Public IP of the Application Gateway."
  value       = azurerm_public_ip.appgateway.ip_address
}

output "health_probe_id" {
  description = "Health Probe Id for the health checks on the Application Gateway."
  value       = azurerm_application_gateway.appgateway.probe[0].id
}

output "backend_address_pool_id" {
  description = "Backend addresss pool, for use with the VM Scale Set."
  value       = azurerm_application_gateway.appgateway.backend_address_pool.0.id
}
