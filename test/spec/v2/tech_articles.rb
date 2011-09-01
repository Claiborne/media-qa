require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'Time'
require 'assert'

describe "tech channel blogroll" do

  include Assert

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end

  it "should return 200 and not be blank", :stg => true do
    check_200_and_not_blank("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
  it "should return articles with a slug key present", :stg => true do
    check_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "blogroll", "id")
  end

  it "should return ten articles", :stg => true do
    article_count("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc",10)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_eql_a_value("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc", "post_type", "article")
  end
  
  it "should return articles in a published state by default ", :stg => true do
    check_key_eql_a_value("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc", "state", "published")
  end
  
  it "should return articles with a category of tech", :stg => true do
    check_category("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc", "tech")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc", "publish_date")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
end

describe "tech topic blogroll" do
 
  include Assert

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end
  
  ['3ds', 'android', 'home-theatre', 'ipad', 'ipod', 'iphone', 'lifestyle', 'mac', 'wii-u', 'pc', 'ps-vita', 'ps3', 'xbox-360', 'wp7'].each do |topic|
    
    it "should return 200 and not be blank for #{topic}", :stg => true do
      check_200_and_not_blank("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&tags=#{topic}&sort=publish_date&order=desc")
    end
  
  end  
end
  
describe "tech article page" do

  include Assert

  before(:all) do

  end
  
  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do
  
  end

  it "should return 200 and not be blank using slug report-iphone-5-coming-to-sprint", :stg => true do
    check_200_and_not_blank("/v2/articles.json?post_type=article&slug=report-iphone-5-coming-to-sprint")
  end
end