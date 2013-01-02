require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'

describe "Authors - /v2/authors" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = PathConfig.new
  end

  before(:each) do
    
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