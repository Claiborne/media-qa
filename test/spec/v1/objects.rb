require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "objects" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return valid object for us locale" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/objects/827005.json.us"    
   response.code.should eql(200)
   data = JSON.parse(response.body)      
  end

  it "should return error when object id is missing" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/objects/"){|response, request, result|
   response.code.should eql(500)
   #data = JSON.parse(response.body)
   }
  end

  it "should return error using an invalid object id" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/objects/-1.json.us"){|response, request, result|
   response.code.should eql(400)
   response.body.should eql('Invalid Object')
   }
  end
end
