require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "Authors - /v2/authors" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end
  
  it "should return authors: /v2/authors.json" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/authors.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return a specific author: /v2/authors/1852577.json", :prd => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/authors/1852577.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
end