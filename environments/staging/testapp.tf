resource "keycloak_openid_client" "testapp_client" {
    realm_id            = "realm"
    client_id           = "testapp"
    
    name                = "testapp"
    description         = "app description"
    enabled             = true
    
    access_type         = "PUBLIC"

    root_url            = "http://localhost:3000"
    base_url            = "http://localhost:3000"
    valid_redirect_uris = ["http://localhost:3000/*"]
    valid_post_logout_redirect_uris = ["+"]
    web_origins = ["http://localhost:3000"]
    admin_url = "http://localhost:3000" 
    
    login_theme = "login-theme"

    standard_flow_enabled = true
}

resource "keycloak_openid_client_default_scopes" "testapp_client_default_scopes" {
    realm_id  = "realm"
    client_id = keycloak_openid_client.testapp_client.id

    default_scopes = [
        "email",
        "profile",
        "roles",
        "web-origins"
    ]
}