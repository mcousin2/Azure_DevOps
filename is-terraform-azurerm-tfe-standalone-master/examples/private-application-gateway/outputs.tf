output "bastion" {
  description = "Bastion access values."
  value = {
    fqdn             = module.networking.bastion.fqdn
    username         = module.networking.bastion.username
    private_key_path = abspath(local_file.tfe-pem.filename)
  }
}

output "tfe" {
  description = "TFE access values."
  value = {
    app_url          = "https://${local.hostname}"
    console_url      = "https://${local.hostname}:8800"
    lb_private_ip    = module.load-balancer.private_ip
    console_password = module.configs.console_password
  }
}
