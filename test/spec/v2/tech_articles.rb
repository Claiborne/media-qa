require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'Time'
require 'assert'

describe "tech channel blogroll" do #TODO defaults

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
    200_and_not_blank("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end

  it "should return articles with a slug", :stg => true do
    articles_with_a_slug("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=&order=desc")
  end
  
  it "should return ten articles", :stg => true do
    ten_articles("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
  it "should return articles with a post_type of article", :stg => true do
    articles_with_a_post_type_of_article("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
  it "should return articles sorted by publish date", :stg => true do
    articles_sorted_by_publish_date("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
  it "should return articles in a published state by default ", :stg => true do
    articles_in_a_published_state_by_default("/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
end

describe "tech topic blogroll" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end
  
  ['3ds', 'android', 'home-theatre', 'ipad', 'ipod', 'iphone', 'lifestyle', 'mac', 'wii-u', 'pc', 'ps-vita', 'ps3', 'xbox-360', 'wp7'].each do |topic|
    
    it "should not return a blank Tech/#{topic} blogroll", :stg => true do
      response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&tags=#{topic}&sort=publish_date&order=desc"
      data = JSON.parse(response.body)
      data.length.should > 0
    end
  
  end  
end
  
describe "tech article page" do

  before(:all) do

  end
  
  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do
  
  end
  
  it "should not return a blank sample Tech article (slug=report-iphone-5-coming-to-sprint)", :stg => true do
    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article&slug=report-iphone-5-coming-to-sprint"
    data = JSON.parse(response.body)
    data.length.should > 0
  end
end