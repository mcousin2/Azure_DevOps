output "console_password" {
  description = "The generated password for the admin console."
  value       = random_string.console_password.result
}

output "startup_script" {
  description = "Rendered BASH file to use instead of cloud-init (for cases when cloud-init is not present)."
  value       = data.template_file.startup_script.rendered
}

output "key_vault_secrets" {
  description = "Secrets that can be written to Azure Key Vault and then read from the instance during first boot."
  value = {
    license_b64         = filebase64(var.license_file)
    replicated_conf     = data.template_file.replicated_config.rendered
    replicated_tfe_conf = data.template_file.replicated_tfe_config.rendered
    tls_cert            = var.tls_config.cert
    tls_key             = var.tls_config.key
  }
}
