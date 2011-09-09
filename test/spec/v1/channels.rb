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

  

  it "should return error for empty channel" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/channels"){|response, request, result|
   response.code.should eql(500)
   #data = JSON.parse(response.body)
   }
  end 

  it "should return error for invalid channel" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/channels/0") {|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end 

  ['json','xml'].each do |format|
    it "should return valid channel in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/channels/542.#{format}"              
     response.code.should eql(200)
     if format.eql?("json")
      data = JSON.parse(response.body)
     else
       data = Nokogiri::XML(response.body)
     
     end
    end
  end 
end
