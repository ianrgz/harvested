require 'oauth2'

module Harvest
  class OAuthClient
    attr_accessor :oauth_credentials, :oauth, :authorize_url, :access_token

    #Dynamically define methods for API resources
    #
    #@returns [OAuth2::Response] - Contains the response with correct info from harvest
    %w(clients contacts time tasks projects reports).each do |method|
      define_method(method) do |api_resource|
        response = access_token.get "/#{method}/#{api_resource}" if access_token
      end
    end

    def initialize oauth_credentials
      @oauth_credentials = oauth_credentials
      @oauth = OAuth2::Client.new(@oauth_credentials.client_id, @oauth_credentials.client_secret, site: site, authorize_url: '/oauth2/authorize', token_url: '/oauth2/token')
    end

    #Builds the correct authorize url endpoint
    #
    #@returns [String] - This string contains the authorize URL with proper parameters.
    def authorize_url redirect_uri
      @authorize_url = oauth.auth_code.authorize_url(redirect_uri: redirect_uri, state: 'optional-csrf-token')
    end

    #Sets the site to which requests are going
    def site
      "https://api.harvestapp.com"
    end

    #Returns a token object which can be used to make further requests
    #
    #@returns [OAuth2::AccessToken] - You can retrieve the access_token and the refresh token from this object.
    def get_token authorization_code, redirect_uri
      @access_token = oauth.auth_code.get_token(authorization_code, redirect_uri: redirect_uri, client_id: @oauth_credentials.client_id, client_secret: @oauth_credentials.client_secret, grant_type: 'authorization_code')
    end

    #Generates a fresh token object passing the token retreived from Harvest
    #
    #@returns [OAuth2::AccessToken]
    def token access_token, options = {}
      @access_token = OAuth2::AccessToken.new(self, access_token, options)
    end
  end
end