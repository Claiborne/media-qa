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
  
  ##TODO defaults
  
  #TODO change tech to production
  
  ################################
  #Test parameters one at a time
  ################################

  it "should return articles" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by article post type" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.each do |article|
      article['post_type'].should == 'article'
    end
  end
  
  it "should return articles by slug", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?slug=metal-gear"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by page" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return ten articles" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=10"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return twenty-five articles" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=25"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with xbox-360" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with metal-gear-solid-peace-walker", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=metal-gear-solid-peace-walker"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with xbox-360 and metal-gear-solid-peace-walker", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_tags=true&tags=metal-gear-solid-peace-walker,xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a category of xbox-360" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles with a category of video", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=video"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a category of xbox-360 and video", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_categories=true&categories=xbox-360,video"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by newest first" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=desc"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by oldest first" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=asc"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles using legacy object id", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?legacy_object_id=14276699"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles published at and before the specified date", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?end_date=20110101"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles published at and from the specified date" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?start_date=20110101"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a state of published" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=published"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a state of draft" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=draft"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by author id", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?author_id=1852577"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by external id", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?external_id=1579"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return blog articles for a user's blog page", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?blog_name=clay.ign&per_page=5&page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return a specific blog article", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?slug=smoke-test-722&blog_name=clay.ign&per_page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
end