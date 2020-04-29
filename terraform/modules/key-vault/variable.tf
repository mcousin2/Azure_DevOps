variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "namespace" {
  description = "Name to assign to resources for easy organization."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "subnet_id" {
  description = "The subnet id to place the External Services in."
}

variable "secrets" {
  description = "Secrets to save to the Azure Key Vault."
  type = list(object({
    name         = string
    content_type = string
    value        = string
  }))
  default = []
}

variable "public_ip_allowlist" {
  description = "List of public IPs that need direct access to the PaaS in the Vnet (Optional)."
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}
