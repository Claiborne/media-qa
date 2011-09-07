require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'mongo'

describe "oauth2 token" do

  before(:all) do
  end

  before(:each) do
    RestClient.log = '/tmp/myrestcalls.log' 
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oauth2.yml"
    @config = Configuration.new
    
    @conn = Mongo::Connection.new
    @db = @conn.db('oauth')
    @db.drop_collection('clients')
    @db.drop_collection('entitlements') 
  end

  after(:each) do

  end

  it "should return return token" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200)  
 
   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

   response = RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}", {} 
   response.code.should eql(200)  
   data = JSON.parse(response.body)
   data['access_token'].should_not be_nil
  
  end

    it "should return not return token with invalid type" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200) 

   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

    lambda {
      RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=wrong_type&client_id=#{client_id}&client_secret=#{client_secret}", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('unsupported_grant_type')
    }

  end

   it "should return not return token with invalid client id" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200)

   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

  lambda {
      RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_id=blah&client_secret=#{client_secret}", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('unauthorized_client')
    }
  end

  
   it "should return not return token with invalid secret" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200)

   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

  lambda {
      RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=blah", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('unauthorized_client')
    }
  end

    it "should return not return token with missing client parameter" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200)

   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

  lambda {
      RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_secret=#{client_secret}", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }
  end

    it "should return not return token with missing secret parameter" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test'}
   response.code.should eql(200)

   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

  lambda {
      RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_id=#{client_id}", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }
  end
end
