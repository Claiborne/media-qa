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
   pp data
  end

end
