variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "namespace" {
  description = "Name to assign to resources for easy organization."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "lb_sku" {
  description = "Load Balancer SKU (Standard or Basic)."
  default     = "Standard"
}

variable "common_tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}
