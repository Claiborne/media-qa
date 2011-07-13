require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "guides" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return guides" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides"    
   response.code.should eql(200)
   data = JSON.parse(response.body)   
  end

  ['json','xml'].each do |format|
    it "should return guides in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.#{format}"
     response.code.should eql(200)
     data = JSON.parse(response.body)  
    end
  end

  it "should return guides for xbox 360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?platform="     
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end 

  it "should return error for unsupported platform" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?platform=-1"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides for retro games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?retro=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides sorted by publish date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?sort=popularity"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty sort" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?sort="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for unsupported sort" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?sort=unsupported"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  [25,75].each do |count|
   it "should return limit number of articles to #{count}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides?max=#{count}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
   end
  end

end
