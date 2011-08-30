require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'mongo'

describe "oauth2 admin" do

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
  
  end

end
