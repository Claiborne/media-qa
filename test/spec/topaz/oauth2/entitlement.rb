require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'
require 'mongo'
require 'pp'

describe "oauth2 entitlement" do

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

  it "should create entitlement" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts' , description: 'test entitlement' }
    response.code.should eql(200)  
  
    @db.collection('entitlements').find( { name: 'posts' }).count().should eql(1)
  end

  it "should create return error for missing name parameter" do
    lambda { 
      RestClient.post "http://#{@config.options['baseurl']}/entitlement", { description: 'test entitlement' }
    }.should raise_error(Exception) { |error| 
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }

    @db.collection('entitlements').find().count().should eql(0)
  end

  it "should create entitlement for missing description parameter" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs'}
    response.code.should eql(200)

    @db.collection('entitlements').find( { name: 'blogs' }).count().should eql(1)
  end

  it "should create return error for empty name  parameter" do
    lambda { 
      RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: '', description: 'test entitlement' }
    }.should raise_error(Exception) { |error| 
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_request')
    }   

    @db.collection('entitlements').find().count().should eql(0)
  end

  it "should  list entitlements as json" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 1'}
    response.code.should eql(200)
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'posts', description: 'test entitlement 2'}
    response.code.should eql(200)
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'videos', description: 'test entitlement 3'}
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(3)

    response = RestClient.get "http://#{@config.options['baseurl']}/entitlement/json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['entitlements'].should have(3).items
  end

  it "should only create entitlement if it does not exist" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 1'}
    response.code.should eql(200)
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 2'}
    response.code.should eql(200)
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 3'}
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(1)
  end

  it "should delete entitlement" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 1'}
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(1)

    response = RestClient.delete "http://#{@config.options['baseurl']}/entitlement?name=blogs"
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(0)
  end

  it "should only delete entitlement specified" do
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'blogs', description: 'test entitlement 1'}
    response.code.should eql(200)
    response = RestClient.post "http://#{@config.options['baseurl']}/entitlement", { name: 'videos', description: 'test entitlement 2'}
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(2)

    response = RestClient.delete "http://#{@config.options['baseurl']}/entitlement?name=blogs"
    response.code.should eql(200)
    @db.collection('entitlements').find().count().should eql(1)
    doc = @db.collection('entitlements').find_one( {name: 'videos' })
    doc['name'].should eql('videos')
  end

  it "should error on delete invalid entitlement" do
    lambda { 
      RestClient.delete "http://#{@config.options['baseurl']}/entitlement?name=blogs"
    }.should raise_error(Exception) { |error| 
      error.response.code.should eql(400)
      data = JSON.parse(error.response.body)
      data['error'].should eql('invalid_scope')
    }
 end

 it "should create return error for missing name parameter on delete" do
   lambda {
     RestClient.delete "http://#{@config.options['baseurl']}/entitlement"
   }.should raise_error(Exception) { |error|
     error.response.code.should eql(400)
     data = JSON.parse(error.response.body)
     data['error'].should eql('invalid_request')
   }
     
   @db.collection('entitlements').find().count().should eql(0)
 end

end
