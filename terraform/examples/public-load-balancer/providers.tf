provider "azurerm" {
  version = ">= 2.0"
  features {}
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
