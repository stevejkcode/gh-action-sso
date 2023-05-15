terraform {
    required_providers {
        keycloak = {
            source = "mrparkers/keycloak"
            version = "4.1.0"
        }
    }
}

variable "username" {
    description = "Keycloak Admin username"
    type        = string
}

variable "password" {
    description = "Keycloak Admin password"
    type        = string
}

variable "url" {
    description = "Keycloak main URL"
    type        = string
}

provider "keycloak" {
    client_id  = "admin-cli"
    username   = var.username
    password   = var.password
    url        = var.url
}

# resource "keycloak_realm" "realm" {
#     realm   = "realm"
#     enabled = true
#     display_name = "REALM" 

#     login_theme = "login-theme"

#     default_signature_algorithm = "RS256"

#     smtp_server {
#         from = "admin@example.org"
#         from_display_name = "Admin"
#         host              = "keycloak-mail"
#         port              = "1025"
#         ssl               = false
#         starttls          = false
#     }
# }