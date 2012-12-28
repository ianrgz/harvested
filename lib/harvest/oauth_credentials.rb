module Harvest
  class OAuthCredentials < Struct.new(:client_id, :client_secret)
    def valid?
      !client_id.nil? && !client_secret.nil?
    end
  end
end