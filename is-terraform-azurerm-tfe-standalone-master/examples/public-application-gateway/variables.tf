# Required
variable "namespace" {
  description = "The name to prefix to resources to keep them unique."
}

variable "location" {
  description = "The location to place all the resources."
}

variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`."
}

variable "subdomain" {
  description = "The subdomain you wish to use `mycompany-tfe`"
}

variable "distribution" {
  description = "The images tested for the TFE submodule. (ubuntu or rhel)."
}

# Optional
variable "vnet_address_space" {
  description = "The virtual network address CIDR."
  default     = "10.0.0.0/16"
}

variable "tfe_license_file" {
  description = "Full local path to a valid TFE license file (*.rli)"
  default     = "./keys/tfe-license.rli"
}

variable "certificate_path" {
  description = "The path on disk that has the PFX certificate."
  default     = "./keys/certificate.pfx"
}

variable "certificate_password" {
  description = "The PFX certificate password."
  default     = ""
}

variable "public_ip_allowlist" {
  description = "List of public IP addresses to allow into the network. This is required for access to the PaaS services (AKV, SA, Postgres) and the bastion."
  type        = list
  default     = []
}

variable "vm_admin_username" {
  description = "The username to login to the TFE Virtual Machines"
  default     = "tfeadmin"
}

variable "tfe_airgap_url" {
  description = "The encoded Storage Account SAS URL to download an airgap bundle."
  default     = ""
}

variable "tfe_replicated_url" {
  description = "The encoded Storage Account SAS URL to download an replicated tar."
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resource group/resources."
  type        = map
  default     = {}
}
