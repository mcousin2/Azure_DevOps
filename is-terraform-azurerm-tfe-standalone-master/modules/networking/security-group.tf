# Only allows SSH from white list IPs
resource "azurerm_network_security_rule" "rule-SSH" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.networking.name
  count                       = length(var.public_ip_allowlist)
  name                        = "SSH-${count.index}"
  description                 = "SSH open for debugging from: ${var.public_ip_allowlist[count.index]}"
  priority                    = 100 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.public_ip_allowlist[count.index]
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "rule-tfe-application" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "TFEApp"
  description                 = "Allow HTTPS (443) traffic for the TFE Application."
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "rule-tfe-console" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "TFEConsole"
  description                 = "Allow port 8800 traffic for the TFE Console."
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8800"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Needed for Application Gateway rule on vnet
resource "azurerm_network_security_rule" "rule-nsg" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "nsg"
  description                 = "Port range required for Azure infrastructure communication."
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# DEBUG only - uncomment to allow all the things in
# resource "azurerm_network_security_rule" "rule-tfe-all" {
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.networking.name
#   name                        = "TFEALL"
#   description                 = "Allow all the things..."
#   priority                    = 2002
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
# }
