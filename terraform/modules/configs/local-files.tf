# Optionally copy the rendered files locally for debugging purposes
resource "local_file" "replicated-conf" {
  filename = "./.terraform/replicated-conf.json"
  content  = data.template_file.replicated_config.rendered
}

resource "local_file" "replicated-tfe-conf" {
  filename = "./.terraform/replicated-tfe-conf.json"
  content  = data.template_file.replicated_tfe_config.rendered
}

resource "local_file" "startup_script" {
  filename = "./.terraform/startup_script.sh"
  content  = data.template_file.startup_script.rendered
}
