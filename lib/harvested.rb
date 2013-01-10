require 'httparty'
require 'base64'
require 'delegate'
require 'hashie'
require 'json'
require 'time'
require 'csv'

require 'ext/array'
require 'ext/hash'
require 'ext/date'
require 'ext/time'

require 'harvest/credentials'
require 'harvest/oauth_credentials'
require 'harvest/oauth_client'
require 'harvest/errors'
require 'harvest/hardy_client'
require 'harvest/timezones'

require 'harvest/base'

%w(crud activatable).each {|a| require "harvest/behavior/#{a}"}
%w(model client contact project task user rate_limit_status task_assignment user_assignment expense_category expense time_entry invoice_category line_item invoice invoice_payment).each {|a| require "harvest/#{a}"}
%w(base account clients contacts projects tasks users task_assignments user_assignments expense_categories expenses time reports invoice_categories invoices invoice_payments).each {|a| require "harvest/api/#{a}"}

module Harvest
  VERSION = File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'VERSION'))).strip

  class << self

    # Creates a standard client that will raise all errors it encounters
    #
    # == Options
    # * +:ssl+ - Whether or not to use SSL when connecting to Harvest. This is dependent on whether your account supports it. Set to +true+ by default
    # == Examples
    #   Harvest.client('mysubdomain', 'myusername', 'mypassword', :ssl => false)
    #
    # @return [Harvest::Base]
    def client(subdomain, username, password, options = {})
      Harvest::Base.new(subdomain, username, password, options)
    end

    # Creates a hardy client that will retry common HTTP errors it encounters and sleep() if it determines it is over your rate limit
    #
    # == Options
    # * +:ssl+ - Whether or not to use SSL when connecting to Harvest. This is dependent on whether your account supports it. Set to +true+ by default
    # * +:retry+ - How many times the hardy client should retry errors. Set to +5+ by default.
    #
    # == Examples
    #   Harvest.hardy_client('mysubdomain', 'myusername', 'mypassword', :ssl => true, :retry => 3)
    #
    # == Errors
    # The hardy client will retry the following errors
    # * Harvest::Unavailable
    # * Harvest::InformHarvest
    # * Net::HTTPError
    # * Net::HTTPFatalError
    # * Errno::ECONNRESET
    #
    # == Rate Limits
    # The hardy client will make as many requests as it can until it detects it has gone over the rate limit. Then it will +sleep()+ for the how ever long it takes for the limit to reset. You can find more information about the Rate Limiting at http://www.getharvest.com/api
    #
    # @return [Harvest::HardyClient] a Harvest::Base wrapped in a Harvest::HardyClient
    # @see Harvest::Base
    def hardy_client(subdomain, username, password, options = {})
      retries = options.delete(:retry)
      Harvest::HardyClient.new(client(subdomain, username, password, options), (retries || 5))
    end

    # Creates a oauth client that will make all requests to harvest OAuth2 API.
    #
    # == Params
    # * client_id - The app's client id provided in the admin panel of your harvest account.
    # * client_secret - The app's secret token also provided in the admin panel of your harvest account.
    #
    # == Examples
    #   Harvest.oauth_client('someclientid', 'someclientsecret')
    #
    # == Errors
    # The oauth client will raise the following errors
    #
    # invalid_request
    # invalid_client
    # invalid_token
    # invalid_grant
    # unsupported_grant_type
    # invalid_scope
    #
    # @return [Harvest::OAuthClient]
    # @see Harvest::OAuthClient
    def oauth_client client_id, client_secret
      credentials = Harvest::OAuthCredentials.new(client_id, client_secret)
      Harvest::OAuthClient.new credentials
    end
  end
end
