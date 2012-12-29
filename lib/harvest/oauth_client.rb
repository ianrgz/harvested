require 'oauth2'
require 'rack'

module Harvest
  class OAuthClient
    attr_accessor :oauth_credentials, :oauth, :authorize_url

    def initialize(oauth_credentials)
      @oauth_credentials = oauth_credentials
      @oauth = OAuth2::Client.new(@oauth_credentials.client_id, @oauth_credentials.client_secret, site: site, authorize_url: '/oauth2/authorize', token_url: '/oauth2/token')
    end

    def valid?
      oauth_credentials.is_a?(Harvest::OAuthCredentials)
    end

    #Builds the correct authorize url endpoint
    def authorize_url redirect_uri
      @authorize_url = oauth.auth_code.authorize_url(redirect_uri: redirect_uri, state: 'optional-csrf-token')
    end

    #Sets the site to which requests are going
    def site
      "https://#{subdomain}.harvestapp.com"
    end

    #TODO: Test that method redirects to correct url
    #Not sure if this method is going to work
    def redirect
      r = Rack::Response.new
      r.write("You're being redirected to harvest endpoint...")
      r.redirect(authorize_url)
      r.finish
    end
  end
end