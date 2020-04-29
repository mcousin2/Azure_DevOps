## Functions
data "template_file" "get-tfe-settings" {
  template = file("${path.module}/templates/startup_script/get-tfe-settings.func")

  vars = {
    source = var.settings-source

    license_b64             = filebase64(var.license_file)
    replicated_conf_b64     = base64encode(data.template_file.replicated_config.rendered)
    replicated_tfe_conf_b64 = base64encode(data.template_file.replicated_tfe_config.rendered)
    tls_cert_b64            = base64encode(var.tls_config.cert)
    tls_key_b64             = base64encode(var.tls_config.key)
  }
}

data "template_file" "install-software" {
  template = file("${path.module}/templates/startup_script/install-software.func")

  vars = {
    distribution = var.distribution
  }
}

data "template_file" "download-tfe-installer" {
  template = file("${path.module}/templates/startup_script/download-tfe-installer.func")

  vars = {
    tfe_install_url = var.tfe_install_url
  }
}

data "template_file" "download-airgap" {
  template = file("${path.module}/templates/startup_script/download-airgap.func")

  vars = {
    tfe_airgap_url     = var.tfe_airgap.url
    tfe_replicated_url = var.tfe_airgap.replicated_url
  }
}

data "template_file" "install-tfe" {
  template = file("${path.module}/templates/startup_script/install-tfe.func")

  vars = {
    airgapped = var.tfe_airgap.enabled
  }
}

data "template_file" "wait-for-ready" {
  template = file("${path.module}/templates/startup_script/wait-for-ready.func")

  vars = {}
}

data "template_file" "startup_script" {
  template = file("${path.module}/templates/startup_script/install.sh")

  vars = {
    function-get-tfe-settings = data.template_file.get-tfe-settings.rendered
    function-install-software = data.template_file.install-software.rendered
    download-tfe-installer    = data.template_file.download-tfe-installer.rendered
    install-tfe               = data.template_file.install-tfe.rendered
    wait-for-ready            = data.template_file.wait-for-ready.rendered

    download-airgap = data.template_file.download-airgap.rendered
    airgapped       = var.tfe_airgap.enabled

    bash_debug_b64 = var.add_bash_debug ? base64encode(file("${path.module}/files/bash-debug.sh")) : ""
  }
}
