locals {
  full_cert = "${tls_locally_signed_cert.cert.cert_pem}\n${tls_self_signed_cert.ca.cert_pem}"
}

resource "local_file" "tls-certificate" {
  filename = "./keys/certificate.cert"
  content  = local.full_cert
}

resource "local_file" "tls-key" {
  filename = "./keys/private.key"
  content  = tls_private_key.cert.private_key_pem
}

resource "local_file" "ca-tls-certificate" {
  filename = "./keys/ca-certificate.cert"
  content  = tls_self_signed_cert.ca.cert_pem
}

resource "local_file" "ca-tls-key" {
  filename = "./keys/ca-private.key"
  content  = tls_private_key.ca.private_key_pem
}

# Null resource way to generate this. Caused concurrency issues on first run since 
# the var.certificate_path HAS to exist on plan
resource "null_resource" "pfx-generation" {
  provisioner "local-exec" {
    command = "openssl pkcs12 -export -out ${var.certificate_path} -inkey ./keys/private.key -in ./keys/certificate.cert -password pass:${var.certificate_password}"
  }
  depends_on = [local_file.tls-key, local_file.tls-certificate]
}

## Optional method to create PFX, but will cause a diff on every plan...
## Runs a script to create a PFX
# data "external" "pfx" {
#   program = ["sh", "${path.module}/files/create_pfx.sh"]
#   query = {
#     key_file      = local_file.tls-key.filename
#     cert_file     = local_file.tls-certificate.filename
#     cert_password = var.certificate_password
#   }

#   depends_on = [local_file.tls-key, local_file.tls-certificate]
# }
