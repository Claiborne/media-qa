require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'
require 'mongo'

describe "oauth2 admin" do

  before(:all) do
  end

  before(:each) do
    RestClient.log = '/tmp/myrestcalls.log' 
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oauth2.yml"
    @config = PathConfig.new
    
    @conn = Mongo::Connection.new
    @db = @conn.db('oauth')
    @db.drop_collection('clients')
    @db.drop_collection('entitlements') 
  end

  after(:each) do

  end

  it "should error on missing client name on register" do
    lambda {
      RestClient.post "http://#{@config.options['baseurl']}/admin/register", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }  
  end

  it "should error on invalid entitlement" do
    lambda {
      RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=media@ign.com&description=test&entitlement=videos", {}
    }.should raise_error(Exception) { |error|
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }
  end

  it "should create client with no description or entitlement" do
    response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=media@ign.com", {}
    response.code.should eql(200)

    @db.collection('clients').find({name: 'media@ign.com'}).count().should eql(1)
  end

 it "should create client" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts' , description: 'test entitlement' }
   response.code.should eql(200)
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'videos' , description: 'test entitlement' }   
   response.code.should eql(200)
   @db.collection('entitlements').find().count().should eql(2)
  
   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=media@ign.com&description=test&entitlement=videos&entitlement=posts", {}
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data['client_id'].should_not be_nil
   data['client_secret'].should_not be_nil 

   @db.collection('clients').find({name: 'media@ign.com'}).count().should eql(1)
  end

 it "should not register duplicate client" do
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts' , description: 'test entitlement' }   
   response.code.should eql(200)
   response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'videos' , description: 'test entitlement' }     
   response.code.should eql(200)
   @db.collection('entitlements').find().count().should eql(2)
  
   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=media@ign.com&description=test&entitlement=videos&entitlement=posts", {}
   response.code.should eql(200)
   @db.collection('clients').find({name: 'media@ign.com'}).count().should eql(1)
  
   response = RestClient.post "http://#{@config.options['baseurl']}/admin/register?name=media@ign.com&description=test&entitlement=videos&entitlement=posts", {}
   response.code.should eql(200)
   @db.collection('clients').find({name: 'media@ign.com'}).count().should eql(1)
 end
end
