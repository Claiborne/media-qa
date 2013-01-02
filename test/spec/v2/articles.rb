require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

describe "Articles - v2/articles" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = PathConfig.new
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return articles: /v2/articles.json" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by article post type: /v2/articles.json?post_type=article" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.each do |article|
      article['post_type'].should == 'article'
    end
  end
  
  it "should return articles by slug: /v2/articles.json?slug=metal-gear", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?slug=metal-gear"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by page: /v2/articles.json?page=1" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return ten articles: /v2/articles.json?per_page=10" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=10"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return twenty-five articles: /v2/articles.json?per_page=25" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?per_page=25"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with xbox-360: /v2/articles.json?tags=xbox-360" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with metal-gear-solid-peace-walker: /v2/articles.json?tags=metal-gear-solid-peace-walker", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?tags=metal-gear-solid-peace-walker"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles tagged with xbox-360 and metal-gear-solid-peace-walker: /v2/articles.json?all_tags=true&tags=metal-gear-solid-peace-walker,xbox-360", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_tags=true&tags=metal-gear-solid-peace-walker,xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a category of xbox-360: /v2/articles.json?categories=xbox-360" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=xbox-360"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles with a category of video: /v2/articles.json?categories=video", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?categories=video"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a category of xbox-360 and video: /v2/articles.json?all_categories=true&categories=xbox-360,video", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?all_categories=true&categories=xbox-360,video"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by newest first: /v2/articles.json?sort=publish_date&order=desc" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=desc"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by oldest first: /v2/articles.json?sort=publish_date&order=asc" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publish_date&order=asc"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles using legacy object id: /v2/articles.json?legacy_object_id=14276699", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?legacy_object_id=14276699"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles published at and before the specified date: /v2/articles.json?end_date=20110101", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?end_date=20110101"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles published at and from the specified date: /v2/articles.json?start_date=20110101" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?start_date=20110101"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a state of published: /v2/articles.json?state=published" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=published"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles with a state of draft: /v2/articles.json?state=draft" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?state=draft"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return articles by author id: /v2/articles.json?author_id=1852577", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?author_id=1852577"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end

  it "should return articles by external id: /v2/articles.json?external_id=1579", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?external_id=1579"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return blog articles for a user's blog page: /v2/articles.json?blog_name=clay.ign&per_page=5&page=1", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?blog_name=clay.ign&per_page=5&page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  it "should return a specific blog article: /v2/articles.json?slug=smoke-test-722&blog_name=clay.ign&per_page=1", :prd => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?slug=smoke-test-722&blog_name=clay.ign&per_page=1"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
end

describe "v2 Article Page -> Article Service Call" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}"+"/v2/articles.json?post_type=article&slug=report-iphone-5-coming-to-sprint"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)  
  end
  
  before(:each) do
    
  end

  after(:each) do
  
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return only one article" do
    article_count(@response, @data, 1)
  end

  it "should return an article with a slug key present" do
    check_key_exists_for_all(@response, @data, "slug")
  end
  
  it "should return an article with a slug value present" do
    check_key_value_exists_for_all(@response, @data, "slug")
  end
  
  it "should return an article with a blogroll key present" do
    check_key_exists_for_all(@response, @data, "blogroll")
  end
  
  it "should return an article with a blogroll headline key present" do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "headline")
  end
  
  it "should return an article with a blogroll summary key present" do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "summary")
  end
  
  it "should return an article with a blogroll id key present" do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "id")
  end
  
  it "should return an article with a headline key present" do
    check_key_exists_for_all(@response, @data, "headline")
  end
  
  it "should return an article with a headline value present" do
    check_key_value_exists_for_all(@response, @data, "headline")
  end
  
  it "should return an article with a post_type of article" do
    check_key_value_equals_for_all(@response, @data, "post_type", "article")
  end
  
  it "should return an article in a published state by default " do
    check_key_value_equals_for_all(@response, @data, "state", "published")
  end
  
  it "should return an article with a category of tech" do
    check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return an article with a publish_date key present" do
    check_key_exists_for_all(@response, @data, "publish_date")
  end
  
  it "should return articles with a publish_date value matching yyyy/mm/dd/" do
    @data.each do |article|
      article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
    end
  end
  
  it "should return an article with a full_text_pages key" do
    check_key_exists_for_all(@response, @data, "full_text_pages")
  end
  
  it "should return an article with a full_text_pages value" do
    check_key_value_exists_for_all(@response, @data, "full_text_pages")
  end
  
  it "should return an article with number_of_pages key present" do
    check_key_exists_for_all(@response, @data, "number_of_pages")
  end
  
  it "should return an article with number_of_pages value present" do
    check_key_value_exists_for_all(@response, @data, "number_of_pages")
  end
  
  it "should return an article with an authors key present" do
    check_key_exists_for_all(@response, @data, "authors")
  end
  
  it "should return an article with an author author_name value present" do
    check_value_of_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_name key present" do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_id key present" do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_id")
  end
  
  it "should return an article with an authors id key present" do
    check_key_within_array_exists_for_all(@response, @data, "authors", "id")
  end
  
 it "should return an article with an id key present" do
    check_key_exists_for_all(@response, @data, "id")
  end
    
  it "should return an article with an id value present" do
    check_key_value_exists_for_all(@response, @data, "id")
  end   
end