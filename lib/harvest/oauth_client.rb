module Harvest
  class OAuthClient
    attr_accessor :oauth_credentials

    def initialize(oauth_credentials)
      @oauth_credentials = oauth_credentials
    end

    def valid?
      oauth_credentials.is_a?(Harvest::OAuthCredentials)
    end
  end
end