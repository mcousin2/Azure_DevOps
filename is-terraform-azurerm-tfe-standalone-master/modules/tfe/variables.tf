variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "namespace" {
  description = "Name to assign to resources for easy organization."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "startup_script" {
  description = "Startup script to install and configure TFE."
  default     = ""
}

variable "subnet_id" {
  description = "The subnet id to place the External Services in."
}

variable "vm_user" {
  description = "VM username and public ssh key."
  type = object({
    username   = string
    public_key = string
  })
}

variable "vm_sku" {
  description = "The VM instance SKU to use."
  default     = "Standard_D2s_v3"
}

variable "tfe_image" {
  description = "Marketplace image for VMSS."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "lb" {
  description = "Load balancer to attach to the VMSS. Type must be one of the following ['ALB', 'AAG']."
  type = object({
    type                    = string
    backend_address_pool_id = string
    health_probe_id         = string
  })
}

variable "keyvault_id" {
  description = "The Azure KeyVault id to use for secrets."
  default     = null
}

variable "common_tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}
