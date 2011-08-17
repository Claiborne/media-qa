require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "articles" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end
  
  #Since no articles currently have values for the following parameters, these parameters will return no articles at this time. No test cases for these parameters have yet been added.
  
  #Also, at the time of this writting, most v2 article use cases have not been fully defined
  
  #TODO: topics parameter
  
  #TODO: topics_all parameter
  
  #TODO: sort parameter other than publish_date when more values are implemented 
  
  #TODO since parameter
  
  #TODO object_platform parameter
  
  #TODO fields parameter
  
  #TODO verify .js format
  
  it "should return articles", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return articles by article post type", :prd => false, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 

  ['json','html'].each do |format|
    it "should return articles in #{format} format", :prd => true, :stg => true do
     response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.#{format}"
     response.code.should eql(200)
     if format.eql?("json")
      data = JSON.parse(response.body)
      data.length.should > 0
     else format.eql?("html")
      data = Nokogiri::XML(response.body)
      data.to_s.length.should > 0
    end
    end
  end

  ['xml'].each do |format|
    it "should return articles in #{format} format", :prd => true, :stg => false do
     response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.#{format}"
     response.code.should eql(200)
     data = Nokogiri::XML(response.body)
     data.to_s.length.should > 0
    end
  end
  
  it "should return articles by page", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?page=2"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return ten articles", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=10"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return twenty-five articles", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=25"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  
  
  it "should return articles tagged with xbox-360", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=xbox-360"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  
  
  it "should return articles tagged with metal-gear-solid-peace-walker", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=metal-gear-solid-peace-walker"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  
  
  it "should return articles tagged with xbox-360 and metal-gear-solid-peace-walker", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_tags=true&tags=metal-gear-solid-peace-walker,xbox-360"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  
  
  it "should return articles with a category of xbox-360", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=xbox-360"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  

  it "should return articles with a category of video", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=video"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles with a category of xbox-360 and video", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_categories=true&categories=xbox-360,video"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles by newest first", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=desc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles by oldest first", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return Halo: Reach articles using legacy object id", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?legacy_object_id=14276699"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles published at and before the specified date", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?end_date=20110101"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles published at and from the specified date", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?start_date=20110101"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return published articles", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=published"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return draft articles", :prd => true, :stg => true do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=draft"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles by author id", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?author_id=1852577"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 

  it "should return articles by external id", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?external_id=1579"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles by slug", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?slug=metal-gear"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end 
  
  it "should return articles by blog author name", :prd => true, :stg => false do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?blog_name=clay.ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end  
end

