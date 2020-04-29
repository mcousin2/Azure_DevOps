resource "random_string" "console_password" {
  length  = 24
  special = false
}

resource "random_string" "encrypt_password" {
  length  = 24
  special = false
}

data "template_file" "replicated_config" {
  template = file("${path.module}/templates/replicated/replicated.conf")

  vars = {
    airgapped        = var.tfe_airgap.enabled
    hostname         = var.hostname
    console_password = random_string.console_password.result
    release_sequence = var.release_sequence
    tls_type         = var.tls_config.self-signed ? "self-signed" : "server-path"
    tls_cert_path    = var.tls_config.self-signed ? "" : "/etc/tfe/tls.crt"
    tls_key_path     = var.tls_config.self-signed ? "" : "/etc/tfe/tls.key"
  }
}

data "template_file" "replicated_tfe_config" {
  template = file("${path.module}/templates/replicated/replicated-tfe.conf")

  vars = {
    hostname           = var.hostname
    enc_password       = random_string.encrypt_password.result
    pg_netloc          = var.postgres_config.netloc
    pg_dbname          = var.postgres_config.dbname
    pg_user            = var.postgres_config.user
    pg_password        = var.postgres_config.password
    pg_extra_params    = var.postgres_config.extra_params
    azure_account_name = var.object_store_config.account_name
    azure_account_key  = var.object_store_config.account_key
    azure_container    = var.object_store_config.container
  }
}
