require 'spec_helper'

#Harvest Oauth Credentials
describe Harvest::OAuthCredentials do
  context '#Validations' do
    it 'should be valid given a client id and client secret' do
      Harvest::OAuthCredentials.new('someclientid', 'someclientsecret').should be_valid
    end

    it 'should not be valid without a client id and client secret' do
      Harvest::OAuthCredentials.new(nil, ENV['HARVEST_SECRET']).should_not be_valid
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
end