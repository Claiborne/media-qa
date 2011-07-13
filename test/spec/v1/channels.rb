require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "channels" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return valid channel" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/channels/"    
   response.code.should eql(200)
   data = JSON.parse(response.body)   
  end

  it "should return error for empty channel" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/channels"              
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end 

  it "should return error for invalid channel" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/channels/0"              
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end 

  ['json','xml'].each do |format|
    it "should return valid channel" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/channels/542.#{format}"              
     response.code.should eql(200)
    end
  end 
end
