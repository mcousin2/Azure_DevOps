locals {
  full_cert = "${acme_certificate.tls.certificate_pem}\n${acme_certificate.tls.issuer_pem}"
}

resource "local_file" "pfx" {
  filename       = "./keys/acme.pfx"
  content_base64 = acme_certificate.tls.certificate_p12
}

resource "local_file" "tls-issuer" {
  filename = "./keys/issuer.cert"
  content  = acme_certificate.tls.issuer_pem
}

resource "local_file" "tls-certificate" {
  filename = "./keys/certificate.cert"
  content  = local.full_cert
}

resource "local_file" "tls-key" {
  filename = "./keys/private.key"
  content  = acme_certificate.tls.private_key_pem
}

# Null resource way to generate this. Caused concurrency issues on first run since 
# the var.certificate_path HAS to exist on plan
resource "null_resource" "pfx-generation" {
  provisioner "local-exec" {
    command = "openssl pkcs12 -export -out ${var.certificate_path} -inkey ./keys/private.key -in ./keys/certificate.cert -certfile ./keys/issuer.cert -password pass:${var.certificate_password}"
  }
  depends_on = [local_file.tls-key, local_file.tls-certificate, local_file.tls-issuer]
}

## Optional method to create PFX, but will cause a diff on every plan...
## Runs a script to create a PFX
# data "external" "pfx" {
#   program = ["sh", "${path.module}/files/create_pfx.sh"]
#   query = {
#     key_file      = local_file.tls-key.filename
#     cert_file     = local_file.tls-certificate.filename
#     issuer_file   = local_file.tls-issuer.filename
#     cert_password = var.certificate_password
#   }

#   depends_on = [local_file.tls-key, local_file.tls-certificate, local_file.tls-issuer]
# }
