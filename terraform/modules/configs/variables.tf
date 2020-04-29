variable "distribution" {
  type        = string
  description = "Type of linux distribution to use. (ubuntu or rhel)."
  default     = "ubuntu"
}

variable "settings-source" {
  type        = string
  description = "Source of the settings, either local or azkeyvault. When local, you must pass in tls_config, postgres_config, and object_store_config. When azkeyvault, settings are read from azure key vault at run time."
  default     = "local"
}

variable "tfe_install_url" {
  type        = string
  description = "TFE installer script url. Defaults to HashiCorp hosted link."
  default     = "https://install.terraform.io/ptfe/stable"
}

variable "tfe_airgap" {
  description = "TFE airgap bundlle url."
  type = object({
    enabled        = bool
    url            = string
    replicated_url = string
  })
  default = {
    enabled        = false
    url            = ""
    replicated_url = ""
  }
}

variable "release_sequence" {
  type        = string
  description = "The sequence ID for the Terraform Enterprise version to pin the cluster to."
  default     = "latest"
}

variable "hostname" {
  description = "FQDN of the tfe application (i.e. tfe.company.com)."
}

variable "license_file" {
  type        = string
  description = "Path to license file for the application."
}

variable "tls_config" {
  description = "TLS configuration to use with TFE. Default will use self-signed."
  type = object({
    self-signed = bool
    cert        = string
    key         = string
  })
  default = {
    self-signed = true
    cert        = ""
    key         = ""
  }
}

variable "postgres_config" {
  description = "Postgres configuration."
  type = object({
    netloc       = string
    dbname       = string
    user         = string
    password     = string
    extra_params = string
  })
  default = {
    netloc       = ""
    dbname       = ""
    user         = ""
    password     = ""
    extra_params = ""
  }
}

variable "object_store_config" {
  description = "Object storage configuration."
  type = object({
    account_name = string
    account_key  = string
    container    = string
  })
  default = {
    account_name = ""
    account_key  = ""
    container    = ""
  }
}

variable "add_bash_debug" {
  description = "If set to true, write some helpful debugging Bash bits to /etc/profile.d/tfe.sh."
  type        = bool
  default     = false
}
