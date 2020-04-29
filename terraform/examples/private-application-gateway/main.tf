resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.namespace)
  location = var.location
  tags     = var.tags
}

module "tls" {
  source               = "../../modules/tls-private"
  domain               = var.domain
  hostname             = local.hostname
  certificate_path     = var.certificate_path
  certificate_password = var.certificate_password
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  namespace           = var.namespace
  vnet_address_space  = var.vnet_address_space
  public_ip_allowlist = var.public_ip_allowlist

  subnet_address_spaces = [
    {
      name          = var.namespace
      address_space = cidrsubnet(var.vnet_address_space, 8, 0)
    },
    {
      name          = "applicationgateway"
      address_space = cidrsubnet(var.vnet_address_space, 8, 1)
    }
  ]

  bastion = {
    username   = var.vm_admin_username
    public_key = tls_private_key.tfe.public_key_openssh
  }

  common_tags = var.tags
}

module "external-services" {
  source = "../../modules/external-services"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  namespace           = var.namespace
  subnet_id           = module.networking.networking.subnet_ids[var.namespace]
  public_ip_allowlist = var.public_ip_allowlist

  common_tags = var.tags
}

module "configs" {
  source = "../../modules/configs"

  hostname       = local.hostname
  add_bash_debug = true
  distribution   = var.distribution # ["ubuntu", "rhel"]

  settings-source     = "azkeyvault" # ["local", "azkeyvault"]
  license_file        = var.tfe_license_file
  postgres_config     = module.external-services.postgres_config
  object_store_config = module.external-services.object_storage_config

  tls_config = {
    self-signed = false
    cert        = module.tls.cert
    key         = module.tls.key
  }

  # Optional
  # tfe_airgap = {
  #   enabled        = true
  #   url            = var.tfe_airgap_url
  #   replicated_url = var.tfe_replicated_url
  # }
}

module "key-vault" {
  source = "../../modules/key-vault"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  namespace           = var.namespace
  subnet_id           = module.networking.networking.subnet_ids[var.namespace]
  public_ip_allowlist = var.public_ip_allowlist

  secrets = [
    {
      name         = "replicated-config"
      content_type = "application/json"
      value        = module.configs.key_vault_secrets.replicated_conf
    },
    {
      name         = "replicated-tfe-config"
      content_type = "application/json"
      value        = module.configs.key_vault_secrets.replicated_tfe_conf
    },
    {
      name         = "replicated-license"
      content_type = "binary/base64"
      value        = module.configs.key_vault_secrets.license_b64
    },
    {
      name         = "tls-cert"
      content_type = "pem"
      value        = module.configs.key_vault_secrets.tls_cert
    },
    {
      name         = "tls-key"
      content_type = "pem"
      value        = module.configs.key_vault_secrets.tls_key
    }
  ]

  common_tags = var.tags
}

module "load-balancer" {
  source = "../../modules/private-application-gateway"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  namespace           = var.namespace
  hostname            = local.hostname
  subnet_id           = module.networking.networking.subnet_ids["applicationgateway"]
  ip_address          = "10.0.1.100"

  tls = {
    name         = module.tls.name
    pfx_b64      = module.tls.pfx_b64
    pfx_password = module.tls.password
    cert_b64     = module.tls.cert_b64
  }

  common_tags = var.tags
}

module "tfe" {
  source = "../../modules/tfe"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  namespace           = var.namespace
  subnet_id           = module.networking.networking.subnet_ids[var.namespace]

  vm_user = {
    username   = var.vm_admin_username
    public_key = tls_private_key.tfe.public_key_openssh
  }

  tfe_image      = local.tfe_images[var.distribution]
  startup_script = module.configs.startup_script
  keyvault_id    = module.key-vault.keyvault.id

  lb = {
    type                    = "AAG"
    backend_address_pool_id = module.load-balancer.backend_address_pool_id
    health_probe_id         = module.load-balancer.health_probe_id
  }

  common_tags = var.tags
}
