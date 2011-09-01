require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'mongo'

describe "oauth2 token" do

  before(:all) do
  end

  before(:each) do
    RestClient.log = '/tmp/myrestcalls.log' 
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/oauth2.yml"
    @config = Configuration.new
    
    @conn = Mongo::Connection.new
    @db = @conn.db('oauth')
    @db.drop_collection('clients')
    @db.drop_collection('entitlements') 
  end

  after(:each) do

  end

  it "should return valid articles" do
   response = RestClient.post "http://#{@config.options['baseurl']}/ent/entitlement?name=posts&description=test", {}
   response.code.should eql(200)  
 
   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=QA&description=test&entitlements=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   client_id = data['client_id']
   client_secret = data['client_secret']

   response = RestClient.post "http://#{@config.options['baseurl']}/token?grant_type=client_credentials&client_id=QA&client_secret=#{client_secret}", {} 
   response.code.should eql(200)  
   data = JSON.parse(response.body)
   access_token = data['access_token']

   response = RestClient.get "http://#{@config.options['baseurl']}/admin/valid?access_token=#{access_token}"
   response.code.should eql(200)

   response = RestClient.delete "http://#{@config.options['baseurl']}/admin/revoke?client_id=QA&client_secret=#{client_secret}&access_token=#{access_token}"
   response.code.should eql(200)
 
   response = RestClient.get  "http://#{@config.options['baseurl']}/admin/valid?access_token=#{access_token}"
   response.code.should eql(400)
  
  end

end
