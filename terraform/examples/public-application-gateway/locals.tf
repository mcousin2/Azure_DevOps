locals {
  hostname = join(".", [var.subdomain, var.domain])
  # These are the TFE images that have been tested. Select these with the var.distributon variable.
  tfe_images = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    rhel = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "7-RAW-CI"
      version   = "latest"
    }
  }
}

# (Optional) Could provide your own keys as well
# Generate public/private SSH keys for tfe
# Store them to disk for easy use
resource "tls_private_key" "tfe" {
  algorithm = "RSA"
}

resource "local_file" "tfe-pem" {
  filename        = "./keys/tfe_rsa.pem"
  content         = tls_private_key.tfe.private_key_pem
  file_permission = "600"
}

resource "local_file" "tfe-pub" {
  filename        = "./keys/tfe_rsa.pub"
  content         = tls_private_key.tfe.public_key_openssh
  file_permission = "600"
}

# DNS - custom to your install, can be done out of band
# resource "azurerm_dns_cname_record" "public" {
#   resource_group_name = "tstraub-ptfe-binaries-rg"
#   zone_name           = var.domain
#   name                = var.subdomain
#   ttl                 = 300
#   record              = module.ag.load_balancer_domain_label
# }

