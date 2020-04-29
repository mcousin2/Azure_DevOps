resource "tls_private_key" "acme" {
  algorithm = "RSA"
}

resource "acme_registration" "tls" {
  account_key_pem = tls_private_key.acme.private_key_pem
  email_address   = format("%s@domainsbyproxy.com", var.domain)
}

resource "acme_certificate" "tls" {
  account_key_pem = acme_registration.tls.account_key_pem
  common_name     = var.hostname

  dns_challenge {
    provider = "azure"
    # AZURE_CLIENT_ID - Client ID.
    # AZURE_CLIENT_SECRET - Client secret.
    # AZURE_RESOURCE_GROUP - Resource group.
    # AZURE_SUBSCRIPTION_ID - Subscription ID.
    # AZURE_TENANT_ID - Tenant ID. 
  }
}
