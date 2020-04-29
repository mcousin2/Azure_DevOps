output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "networking" {
  description = "Networking configuration."
  value = {
    vnet_id   = azurerm_virtual_network.networking.id
    vnet_name = azurerm_virtual_network.networking.name
    # strip out the suffix to match name passed into the module.
    subnet_ids = {
      for subnet in azurerm_subnet.networking :
      trimsuffix(subnet.name, "-subnet") => subnet.id
    }
  }
}

output "bastion" {
  description = "Bastion connectiong configuration."
  value = {
    fqdn     = azurerm_public_ip.bastion.fqdn
    username = var.bastion.username
  }
}
