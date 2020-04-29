output "cert" {
  description = "Full chain certificate in PEM format."
  value       = local.full_cert
}

output "key" {
  description = "Certification key in PEM format."
  value       = tls_private_key.cert.private_key_pem
}

output "name" {
  description = "Readable name of the certificate."
  value       = "tfe-tls-pfx"
}

output "password" {
  description = "The password used to create the PFX."
  value       = var.certificate_password
}

output "pfx_b64" {
  description = "The PFX certification in base64."
  value       = filebase64(var.certificate_path) # null_resource creates this
  # value       = data.external.pfx.result.pfx_b64 # data external creates this
}

output "cert_b64" {
  description = "The PEM certification in base64."
  value       = base64encode(local.full_cert)
}
