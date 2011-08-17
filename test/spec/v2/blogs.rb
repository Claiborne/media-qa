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
  
  it "should return blogs", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  ['json','xml'].each do |format|
    it "should return blogs in #{format} format", :prd => true, :stg => true do
     response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.#{format}"
     response.code.should eql(200)
     if format.eql?("json")
      data = JSON.parse(response.body)
      data.length.should > 0
     else format.eql?("xml")
      data = Nokogiri::XML(response.body)
      data.to_s.length.should > 0
    end
    end
  end
  
  it "should return blogs sorted by by most page views", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=page_views"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs sorted by most unique visitors", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=unique_visitors"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs alphabetically sorted by author", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?sort=path&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return five blog entires", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=5"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return thirty blog entires", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?per_page=30"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs by page", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?page=2"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end

  it "should return blogs by author path", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?path=clay.ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return blogs for /blogs/user-name", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/blogs.json?blog_name=clay.ign&per_page=5&page=1"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
end

