require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'Time'
require 'assert'
require 'tech_nav'

include TechNav

describe "tech api use cases - tech homepage blogroll" do

  include Assert
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)  
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :stg => true do
    check_200(@response, @data)
  end
  
  it "should not be blank", :stg => true do
    check_not_blank(@response, @data)
  end
  
  it "should return articles with a slug key present", :stg => true do
    check_key_exists(@response, @data, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "id")
  end
  
  it "should return articles with a headline key present", :stg => true do
    check_key_exists(@response, @data, "headline")
  end

  it "should return ten articles", :stg => true do
    article_count(@response, @data, 10)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_value_equals(@response, @data, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_value_equals(@response, @data, "state", "published")
  end
  
  it "should return articles with a category of tech", :stg => true do
    check_key_value_within_array_contains(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, "publish_date")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, "full_text_pages")
  end
  
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, "number_of_pages")
  end
  
  it "should return articles with an authors key present", :stg => true do
    check_key_exists(@response, @data, "authors")
  end

  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "id")
  end

  it "should return articles with an id key present", :stg => true do
    check_key_exists(@response, @data, "id")
  end

  it "should return articles with an id value present", :stg => true do
    check_key_value_exists(@response, @data, "id")
  end
    
end

@topic = return_tech_nav
@topic.each do |topic|
describe "tech api use cases - tech/#{topic} blogroll" do
 
  include Assert

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&sort=publish_date&order=desc"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)  
  end

  before(:each) do
    
  end

  after(:each) do

  end
    
  it "should return 200", :stg => true do
    check_200(@response, @data)
  end
  
  it "should not be blank", :stg => true do
    check_not_blank(@response, @data)
  end
    
  it "should return articles tagged #{topic}", :stg => true do
    check_key_value_within_array_contains(@response, @data, "tags", "slug", topic)
  end
    
  it "should return articles with a slug key present", :stg => true do
    check_key_exists(@response, @data, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "id")
  end
    
  it "should return articles with a headline key present", :stg => true do
    check_key_exists(@response, @data, "headline")
  end

  it "should return 20 articles by default", :stg => true do
    article_count(@response, @data, 20)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_value_equals(@response, @data, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_value_equals(@response, @data, "state", "published")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, "publish_date")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, "full_text_pages")
  end
    
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, "number_of_pages")
  end
    
  it "should return articles with an authors key present", :stg => true do
    check_key_exists(@response, @data, "authors")
  end
    
  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
     check_key_within_array_exists(@response, @data, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "id")
  end
    
  it "should return articles with an id key present", :stg => true do
    check_key_exists(@response, @data, "id")
  end
    
  it "should return articles with an id value present", :stg => true do
  check_key_value_exists(@response, @data, "id")
  end
end  
end
  
describe "tech api use cases - v2 article page (slug=report-iphone-5-coming-to-sprint)" do

  include Assert

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&slug=report-iphone-5-coming-to-sprint"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)  
  end
  
  before(:each) do
    
  end

  after(:each) do
  
  end

  it "should return 200", :stg => true do
    check_200(@response, @data)
  end
  
  it "should not be blank", :stg => true do
    check_not_blank(@response, @data)
  end
  
  it "should return an article with a slug key present", :stg => true do
    check_key_exists(@response, @data, "slug")
  end
  
  it "should return an article with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, "slug")
  end
  
  it "should return an article with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, "blogroll")
  end
  
  it "should return an article with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "image_url")
  end
  
  it "should return an article with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "headline")
  end
  
  it "should return an article with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "summary")
  end
  
  it "should return an article with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, "blogroll", "id")
  end
  
  it "should return an article with a headline key present", :stg => true do
    check_key_exists(@response, @data, "headline")
  end
  
  it "should return an article with a headline value present", :stg => true do
    check_key_value_exists(@response, @data, "headline")
  end
  
  it "should return an article with a post_type of article", :stg => true do
    check_key_value_equals(@response, @data, "post_type", "article")
  end
  
  it "should return an article in a published state by default ", :stg => true do
    check_key_value_equals(@response, @data, "state", "published")
  end
  
  it "should return an article with a category of tech", :stg => true do
    check_key_value_within_array_contains(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return an article with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, "publish_date")
  end
  
  it "should return an article with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, "full_text_pages")
  end
  
  it "should return an article with a full_text_pages value", :stg => true do
    check_key_value_exists(@response, @data, "full_text_pages")
  end
  
  it "should return an article with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, "number_of_pages")
  end
  
  it "should return an article with number_of_pages value present", :stg => true do
    check_key_value_exists(@response, @data, "number_of_pages")
  end
  
  it "should return an article with an authors key present", :stg => true do
    check_key_exists(@response, @data, "authors")
  end
  
  it "should return an article with an author author_name value present", :stg => true do
    check_value_of_key_within_array_exists(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_name key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_id key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "author_id")
  end
  
  it "should return an article with an authors id key present", :stg => true do
    check_key_within_array_exists(@response, @data, "authors", "id")
  end
  
 it "should return an article with an id key present", :stg => true do
    check_key_exists(@response, @data, "id")
  end
    
  it "should return an article with an id value present", :stg => true do
    check_key_value_exists(@response, @data, "id")
  end   
  
end