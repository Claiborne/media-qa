require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "Blogs - /v2/blogs" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
  end

  after(:each) do

  end
  
  it "should return blogs: /v2/blogs.json" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs sorted by by most page views: /v2/blogs.json?sort=page_views" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=page_views"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs sorted by most unique visitors: }/v2/blogs.json?sort=unique_visitors" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=unique_visitors"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs alphabetically sorted by author: /v2/blogs.json?sort=path&order=asc" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=path&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return five blog entires: /v2/blogs.json?per_page=5" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=5"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return thirty blog entires: /v2/blogs.json?per_page=30" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=30"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs by page: /v2/blogs.json?page=2" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?page=2"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs by author path: /v2/blogs.json?path=slyclaiborne" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?path=slyclaiborne"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
end

