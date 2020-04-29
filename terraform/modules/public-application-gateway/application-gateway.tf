locals {
  backend_address_pool_name         = format("%s-beap", var.namespace)
  app_frontend_port_name            = format("%s-app-feport", var.namespace)
  console_frontend_port_name        = format("%s-console-feport", var.namespace)
  frontend_ip_configuration_name    = format("%s-feip", var.namespace)
  app_http_setting_name             = format("%s-app-htst", var.namespace)
  console_http_setting_name         = format("%s-console-htst", var.namespace)
  app_listener_name                 = format("%s-app-httplstn", var.namespace)
  console_listener_name             = format("%s-console-httplstn", var.namespace)
  app_request_routing_rule_name     = format("%s-app-rqrt", var.namespace)
  console_request_routing_rule_name = format("%s-console-rqrt", var.namespace)
  redirect_configuration_name       = format("%s-rdrcfg", var.namespace)
  app_probe_name                    = format("%s-app-probe", var.namespace)
  console_probe_name                = format("%s-console-probe", var.namespace)
  gateway_ip_configuration_name     = format("%s-ip-configuration", var.namespace)
}

resource "random_pet" "endpoint" {
  length = 2
}

resource "azurerm_public_ip" "appgateway" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-appgateway-pubip", var.namespace)
  allocation_method   = "Static"
  domain_name_label   = random_pet.endpoint.id
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgateway" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-appgateway", var.namespace)

  # WAF_v2 or Standard_v2
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  # zones = var.vm_scale_set.zones
  zones = ["1", "2", "3"]

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.app_frontend_port_name
    port = 443
  }

  frontend_port {
    name = local.console_frontend_port_name
    port = 8800
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.app_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    host_name             = var.hostname
    probe_name            = local.app_probe_name
  }

  backend_http_settings {
    name                  = local.console_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 8800
    protocol              = "Https"
    request_timeout       = 60
    host_name             = var.hostname
    probe_name            = local.console_probe_name
  }

  http_listener {
    name                           = local.app_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.app_frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.tls.name
  }

  http_listener {
    name                           = local.console_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.console_frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.tls.name
  }

  ssl_certificate {
    name     = var.tls.name
    data     = var.tls.pfx_b64
    password = var.tls.pfx_password
  }

  probe {
    name                                      = local.app_probe_name
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Https"
    path                                      = "/_health_check"
    interval                                  = 2
    timeout                                   = 5
    unhealthy_threshold                       = 3
  }

  probe {
    name                                      = local.console_probe_name
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Https"
    path                                      = "/authenticate"
    interval                                  = 2
    timeout                                   = 5
    unhealthy_threshold                       = 3
  }

  request_routing_rule {
    name                       = local.app_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.app_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.app_http_setting_name
  }

  request_routing_rule {
    name                       = local.console_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.console_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.console_http_setting_name
  }

  # # TODO: Need to verify this isnt going to break anything.
  # waf_configuration {
  #   enabled                  = false
  #   firewall_mode            = "Prevention"
  #   rule_set_type            = "OWASP"
  #   rule_set_version         = "3.1"
  #   file_upload_limit_mb     = 100
  #   max_request_body_size_kb = 128
  # }
}
