require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'Time'
require 'assert'

describe "tech channel blogroll" do

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

  it "should return 200 and not be blank", :stg => true do
    check_200_and_not_blank(@response, @data, @url)
  end
  
  it "should return articles with a slug key present", :stg => true do
    check_key_exists(@response, @data, @url, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, @url, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "id")
  end
  
  it "should return articles with a headline key present", :stg => true do
    check_key_exists(@response, @data, @url, "headline")
  end

  it "should return ten articles", :stg => true do
    article_count(@response, @data, @url, 10)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "state", "published")
  end
  
  it "should return articles with a category of tech", :stg => true do
    check_key_within_key_value(@response, @data, @url, "categories", "slug", "tech")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, @url, "publish_date")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data, @url)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, @url, "full_text_pages")
  end
  
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, @url, "number_of_pages")
  end
  
  it "should return articles with an authors key present", :stg => true do
    check_key_exists(@response, @data, @url, "authors")
  end

  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "id")
  end

  it "should return articles with an id key present", :stg => true do
    check_key_exists(@response, @data, @url, "id")
  end

  it "should return articles with an id value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "id")
  end
    
end

['3ds', 'android', 'home-theatre', 'ipad', 'ipod', 'iphone', 'lifestyle', 'mac', 'wii-u', 'pc', 'ps-vita', 'ps3', 'xbox-360', 'wp7'].each do |topic|

describe "tech/#{topic} blogroll" do
 
  include Assert

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&tags=#{topic}&sort=publish_date&order=desc"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)  
  end

  before(:each) do
    
  end

  after(:each) do

  end
    
  it "should return 200 and not be blank", :stg => true do
    check_200_and_not_blank(@response, @data, @url)
  end
    
  it "should return articles tagged #{topic}", :stg => true do
    check_key_within_key_value(@response, @data, @url, "tags", "slug", topic)
  end
    
  it "should return articles with a slug key present", :stg => true do
    check_key_exists(@response, @data, @url, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, @url, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "id")
  end
    
  it "should return articles with a headline key present", :stg => true do
    check_key_exists(@response, @data, @url, "headline")
  end

  it "should return ten articles", :stg => true do
    article_count(@response, @data, @url, 10)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "state", "published")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, @url, "publish_date")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data, @url)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, @url, "full_text_pages")
  end
    
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, @url, "number_of_pages")
  end
    
  it "should return articles with an authors key present", :stg => true do
    check_key_exists(@response, @data, @url, "authors")
  end
    
  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
     check_key_within_key_index_exists(@response, @data, @url, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "id")
  end
    
  it "should return articles with an id key present", :stg => true do
    check_key_exists(@response, @data, @url, "id")
  end
    
  it "should return articles with an id value present", :stg => true do
  check_key_value_exists(@response, @data, @url, "id")
  end
end  
end
  
describe "tech article page" do

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

  it "should return 200 and not be blank using slug report-iphone-5-coming-to-sprint", :stg => true do
    check_200_and_not_blank(@response, @data, @url)
  end
  
  it "should return an article with a slug key present", :stg => true do
    check_key_exists(@response, @data, @url, "slug")
  end
  
  it "should return an article with a slug value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "slug")
  end
  
  it "should return an article with a blogroll key present", :stg => true do
    check_key_exists(@response, @data, @url, "blogroll")
  end
  
  it "should return an article with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "image_url")
  end
  
  it "should return an article with a blogroll headline key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "headline")
  end
  
  it "should return an article with a blogroll summary key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "summary")
  end
  
  it "should return an article with a blogroll id key present", :stg => true do
    check_key_within_key_exists(@response, @data, @url, "blogroll", "id")
  end
  
  it "should return an article with a headline key present", :stg => true do
    check_key_exists(@response, @data, @url, "headline")
  end
  
  it "should return an article with a headline value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "headline")
  end
  
  it "should return an article with a post_type of article", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "post_type", "article")
  end
  
  it "should return an article in a published state by default ", :stg => true do
    check_key_eql_a_value(@response, @data, @url, "state", "published")
  end
  
  it "should return an article with a category of tech", :stg => true do
    check_key_within_key_value(@response, @data, @url, "categories", "slug", "tech")
  end
  
  it "should return an article with a publish_date key present", :stg => true do
    check_key_exists(@response, @data, @url, "publish_date")
  end
  
  it "should return an article with a full_text_pages key", :stg => true do
    check_key_exists(@response, @data, @url, "full_text_pages")
  end
  
  it "should return an article with a full_text_pages value", :stg => true do
    check_key_value_exists(@response, @data, @url, "full_text_pages")
  end
  
  it "should return an article with number_of_pages key present", :stg => true do
    check_key_exists(@response, @data, @url, "number_of_pages")
  end
  
  it "should return an article with number_of_pages value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "number_of_pages")
  end
  
  it "should return an article with an authors key present", :stg => true do
    check_key_exists(@response, @data, @url, "authors")
  end
  
  it "should return an article with an author author_name value present", :stg => true do
    check_key_within_key_value_exists(@response, @data, @url, "authors", "author_name")
  end
  
  it "should return an article with an authors author_name key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "author_name")
  end
  
  it "should return an article with an authors author_id key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "author_id")
  end
  
  it "should return an article with an authors id key present", :stg => true do
    check_key_within_key_index_exists(@response, @data, @url, "authors", "id")
  end
  
 it "should return an article with an id key present", :stg => true do
    check_key_exists(@response, @data, @url, "id")
  end
    
  it "should return an article with an id value present", :stg => true do
    check_key_value_exists(@response, @data, @url, "id")
  end   
  
end