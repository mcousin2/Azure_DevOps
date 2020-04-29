locals {
  lb_frontend_config_name = "PublicIPAddress"
  lb_backend_config_name  = "BackEndAddressPool"
}

resource "random_pet" "endpoint" {
  length = 2
}

resource "azurerm_public_ip" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-lb-pubip", var.namespace)
  sku                 = var.lb_sku
  allocation_method   = "Static"
  domain_name_label   = random_pet.endpoint.id
  tags                = var.common_tags
}

resource "azurerm_lb" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-lb", var.namespace)
  sku                 = var.lb_sku

  frontend_ip_configuration {
    name                 = local.lb_frontend_config_name
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = var.common_tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
  name                = local.lb_backend_config_name
}

resource "azurerm_lb_probe" "console" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "tfe-app-console-probe"
  protocol            = "Https"
  request_path        = "/authenticate"
  port                = 8800
}

resource "azurerm_lb_probe" "app" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "tfe-app-app-probe"
  protocol            = "Https"
  request_path        = "/_health_check"
  port                = 443
}

resource "azurerm_lb_rule" "lb-console" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  probe_id                       = azurerm_lb_probe.console.id
  name                           = "ConsoleRule"
  protocol                       = "Tcp"
  frontend_port                  = 8800
  backend_port                   = 8800
  frontend_ip_configuration_name = local.lb_frontend_config_name
}

resource "azurerm_lb_rule" "lb-app" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  probe_id                       = azurerm_lb_probe.app.id
  name                           = "AppRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = local.lb_frontend_config_name
}
