module Harvest
  class OAuthCredentials < Struct.new(:client_id, :client_secret)
    # attr_accessor :client_id, :client_secret

    # def initilize client_id, client_secret
    #   @client_id, @client_secret = client_id, client_secret
    # end

    def valid?
      !client_id.nil? && !client_secret.nil?
    end
  end
end