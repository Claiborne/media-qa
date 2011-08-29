require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "blogs" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
  end

  after(:each) do

  end
  
  it "should return blogs" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs sorted by by most page views" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=page_views"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs sorted by most unique visitors" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=unique_visitors"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs alphabetically sorted by author" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=path&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return five blog entires" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=5"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return thirty blog entires" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=30"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs by page" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?page=2"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs by author path" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?path=clay.ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
end

