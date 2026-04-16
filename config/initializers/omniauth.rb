# OmniAuth configuration
# Sets the full host URL for callbacks and proper redirect handling
OmniAuth.config.full_host = ENV.fetch('FRONTEND_URL', 'http://localhost:3000')

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil), ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil), {
    provider_ignores_state: true
  }

  # OpenID Connect provider (Zitadel, Keycloak, Authentik, etc.)
  if ENV['OIDC_CLIENT_ID'].present?
    provider :openid_connect,
             name: :oidc,
             scope: [:openid, :email, :profile],
             response_type: :code,
             issuer: ENV.fetch('OIDC_ISSUER', nil),
             discovery: true,
             client_options: {
               identifier: ENV.fetch('OIDC_CLIENT_ID', nil),
               secret: ENV.fetch('OIDC_CLIENT_SECRET', nil),
               redirect_uri: "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/omniauth/oidc/callback"
             }
  end
end
