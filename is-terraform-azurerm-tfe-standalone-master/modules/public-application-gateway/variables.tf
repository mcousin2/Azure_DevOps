variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "namespace" {
  description = "Name to assign to resources for easy organization."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "hostname" {
  description = "FQDN of the tfe application (i.e. tfe.company.com)"
}

variable "subnet_id" {
  description = "The subnet id to place the External Services in."
}

variable "tls" {
  description = "TLS Certificate configuration."
  type = object({
    name         = string
    pfx_b64      = string
    pfx_password = string
  })
}
variable "common_tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}
