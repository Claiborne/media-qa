require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'

describe "guides" do

  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = PathConfig.new
  end

  after(:each) do

  end

  it "should return guides" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)   
  end

  ['json','xml'].each do |format|
    it "should return guides in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.#{format}"
     response.code.should eql(200)
     if format.eql?('json')
      data = JSON.parse(response.body)
     else
       data = Nokogiri::XML(response.body)
     end
    end
  end

  it "should return guides for xbox 360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?platform=661955"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end 

  it "should return error for unsupported platform" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?platform=-1"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides for retro games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?retro=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides sorted by publish date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return guides sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=popularity"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty sort" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/guides.json?sort="){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  it "should return error for unsupported sort" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/guides.json?sort=unsupported"){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  [25,75].each do |count|
   it "should return limit number of articles to #{count}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?max=#{count}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
   end
  end

end
