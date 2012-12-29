require 'spec_helper'

#Harvest Oauth Credentials
describe Harvest::OAuthCredentials do
  let(:valid_credentials) { Harvest::OAuthCredentials.new('someclientid', 'someclientsecret') }
  let(:invalid_credentials) { Harvest::OAuthCredentials.new(nil, ENV['HARVEST_SECRET']) }

  context '#Validations' do
    it 'should be valid given a client id and client secret' do
      valid_credentials.should be_valid
    end

    it 'should not be valid without a client id and client secret' do
      invalid_credentials.should_not be_valid
      Harvest::OAuthCredentials.new(ENV['HARVEST_IDENTIFIER'], nil).should_not be_valid
    end
  end
end

#Harvest OAuth Authorization
describe Harvest::OAuthClient do
  context '#validations' do
    it 'should be valid given the proper oauth credentials' do
      Harvest::OAuthClient.new(FactoryGirl.build(:oauth_credentials)).should be_valid
    end
  end

  context '#requests' do
    it 'should build the authorize URL given the proper credentials' do
      client = Harvest::OAuthClient.new(FactoryGirl.build(:oauth_credentials))
      authorize_url = client.authorize_url('http://supercoolsite.com')
      authorize_url.length.should >= 0
      puts authorize_url
    end
  end
end