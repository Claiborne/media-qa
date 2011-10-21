require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'time'
require 'assert'
require 'tech_nav'

include Assert
include TechNav

describe "Tech Api: Home Page Blogroll Widget Service Call" do
  
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
    check_key_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists_for_all(@response, @data, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "id")
  end
  
  it "should return articles with a headline key present", :stg => true do
    check_key_exists_for_all(@response, @data, "headline")
  end

  it "should return ten articles", :stg => true do
    article_count(@response, @data, 10)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_value_equals_for_all(@response, @data, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_value_equals_for_all(@response, @data, "state", "published")
  end
  
  it "should return articles with a category of tech", :stg => true do
    check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists_for_all(@response, @data, "publish_date")
  end
  
  it "should return articles with a publish_date value matching yyyy/mm/dd/", :stg => true do
    @data.each do |article|
      article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
    end
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists_for_all(@response, @data, "full_text_pages")
  end
  
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists_for_all(@response, @data, "number_of_pages")
  end
  
  it "should return articles with an authors key present", :stg => true do
    check_key_exists_for_all(@response, @data, "authors")
  end

  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "id")
  end

  it "should return articles with an id key present", :stg => true do
    check_key_exists_for_all(@response, @data, "id")
  end

  it "should return articles with an id value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "id")
  end
  
  it "should return only unique entries", :stg => true do
    check_no_duplicates(@response, @data)
  end
    
end

describe "Tech Api: Topic Blogroll Widget Service Call" do
  
  @topic = return_tech_nav
  @topic.each do |topic|
  
  context "Tech #{topic} Topic Page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&all_tags=true&sort=publish_date&order=desc"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)  
  end

  before(:each) do
    
  end

  after(:each) do

  end
    
  it "should return 200", :stg => true do
    puts topic
    puts "http://#{@config.options['baseurl']}#{@url}"
    check_200(@response, @data)
  end
  
  it "should not be blank", :stg => true do
    check_not_blank(@response, @data)
  end
    
  it "should return articles tagged as #{topic}", :stg => true do
    check_key_value_within_array_contains_for_all(@response, @data, "tags", "slug", topic)
  end
  
  it "should return an article with a category of tech", :stg => true do
    check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
  end
    
  it "should return articles with a slug key present", :stg => true do
    check_key_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a blogroll key present", :stg => true do
    check_key_exists_for_all(@response, @data, "blogroll")
  end
  
  it "should return articles with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "image_url")
  end
  
  it "should return articles with a blogroll headline key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "headline")
  end
  
  it "should return articles with a blogroll summary key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "summary")
  end
  
  it "should return articles with a blogroll id key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "id")
  end
    
  it "should return articles with a headline key present", :stg => true do
    check_key_exists_for_all(@response, @data, "headline")
  end

  it "should return 20 articles", :stg => true do
    article_count(@response, @data, 20)
  end
  
  it "should return articles with a post_type of article", :stg => true do
    check_key_value_equals_for_all(@response, @data, "post_type", "article")
  end
  
  it "should return articles in a published state by default", :stg => true do
    check_key_value_equals_for_all(@response, @data, "state", "published")
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists_for_all(@response, @data, "publish_date")
  end
  
  it "should return articles with a publish_date value matching yyyy/mm/dd/", :stg => true do
    @data.each do |article|
      article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
    end
  end
  
  it "should return articles sorted by publish date", :stg => true do
    check_sorted_by_publish_date(@response, @data)
  end
  
  it "should return articles with a full_text_pages key", :stg => true do
    check_key_exists_for_all(@response, @data, "full_text_pages")
  end
    
  it "should return articles with number_of_pages key present", :stg => true do
    check_key_exists_for_all(@response, @data, "number_of_pages")
  end
    
  it "should return articles with an authors key present", :stg => true do
    check_key_exists_for_all(@response, @data, "authors")
  end
    
  it "should return articles with an authors author_name key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return articles with an authors author_id key present", :stg => true do
     check_key_within_array_exists_for_all(@response, @data, "authors", "author_id")
  end
  
  it "should return articles with an authors id key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "id")
  end
    
  it "should return articles with an id key present", :stg => true do
    check_key_exists_for_all(@response, @data, "id")
  end
    
  it "should return articles with an id value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "id")
  end
  
  it "should return only unique entries", :stg => true do
    check_no_duplicates(@response, @data)
  end
  
  end
  end  
end

describe "Tech Api: v2 Article Service Call (slug=report-iphone-5-coming-to-sprint)" do

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
  
  it "should return only one article", :stg => true do
    article_count(@response, @data, 1)
  end

  it "should return an article with a slug key present", :stg => true do
    check_key_exists_for_all(@response, @data, "slug")
  end
  
  it "should return an article with a slug value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "slug")
  end
  
  it "should return an article with a blogroll key present", :stg => true do
    check_key_exists_for_all(@response, @data, "blogroll")
  end
  
  it "should return an article with a blogroll image_url key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "image_url")
  end
  
  it "should return an article with a blogroll headline key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "headline")
  end
  
  it "should return an article with a blogroll summary key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "summary")
  end
  
  it "should return an article with a blogroll id key present", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, "blogroll", "id")
  end
  
  it "should return an article with a headline key present", :stg => true do
    check_key_exists_for_all(@response, @data, "headline")
  end
  
  it "should return an article with a headline value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "headline")
  end
  
  it "should return an article with a post_type of article", :stg => true do
    check_key_value_equals_for_all(@response, @data, "post_type", "article")
  end
  
  it "should return an article in a published state by default ", :stg => true do
    check_key_value_equals_for_all(@response, @data, "state", "published")
  end
  
  it "should return an article with a category of tech", :stg => true do
    check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return an article with a publish_date key present", :stg => true do
    check_key_exists_for_all(@response, @data, "publish_date")
  end
  
  it "should return articles with a publish_date value matching yyyy/mm/dd/", :stg => true do
    @data.each do |article|
      article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
    end
  end
  
  it "should return an article with a full_text_pages key", :stg => true do
    check_key_exists_for_all(@response, @data, "full_text_pages")
  end
  
  it "should return an article with a full_text_pages value", :stg => true do
    check_key_value_exists_for_all(@response, @data, "full_text_pages")
  end
  
  it "should return an article with number_of_pages key present", :stg => true do
    check_key_exists_for_all(@response, @data, "number_of_pages")
  end
  
  it "should return an article with number_of_pages value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "number_of_pages")
  end
  
  it "should return an article with an authors key present", :stg => true do
    check_key_exists_for_all(@response, @data, "authors")
  end
  
  it "should return an article with an author author_name value present", :stg => true do
    check_value_of_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_name key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_name")
  end
  
  it "should return an article with an authors author_id key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "author_id")
  end
  
  it "should return an article with an authors id key present", :stg => true do
    check_key_within_array_exists_for_all(@response, @data, "authors", "id")
  end
  
 it "should return an article with an id key present", :stg => true do
    check_key_exists_for_all(@response, @data, "id")
  end
    
  it "should return an article with an id value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "id")
  end   
end
=begin
describe "Tech Api: Topic Nav Widget Service Call" do
  
  @topic = return_tech_nav
  @topic.each do |topic|
  
  context "Tech #{topic} Topic Page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=xbox-360,news&all_tags=true&sort=publish_date&order=desc"
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
end
=end ###END PROBLEM WITHIN
describe "Tech Api: Discover More Widget Service Call" do

  @topic = return_tech_nav
  @topic.each do |topic|
    
    context "When Tag is #{topic}" do
      
      before(:all) do

        Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
        @config = Configuration.new

        @url = "/v2/articles.json?post_type=article&per_page=2&categories=tech&tags=#{topic}"
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
        check_key_exists_for_all(@response, @data, "slug")
      end

      it "should return articles with a slug value present", :stg => true do
        check_key_value_exists_for_all(@response, @data, "slug")
      end
  
      it "should return 2 articles", :stg => true do
        article_count(@response, @data, 2)
      end

      it "should return an article with a category of tech", :stg => true do
        check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
      end
      
      it "should return articles with a publish_date key present", :stg => true do
        check_key_exists_for_all(@response, @data, "publish_date")
      end

      it "should return articles with a publish_date value matching yyyy/mm/dd/", :stg => true do
        @data.each do |article|
          article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
        end
      end

      it "should return articles tagged as #{topic}", :stg => true do
        check_key_value_within_array_contains_for_all(@response, @data, "tags", "slug", topic)
      end
      
      it "should return articles with a headline key present", :stg => true do
        check_key_exists_for_all(@response, @data, "headline")
      end

      it "should return articles with a value in the headline key", :stg => true do
        headline = []
        @data.each do |article|
          headline << article['headline']
        end
      headline.compact.to_s.delete("^a-zA-Z").length.should be > 2
      end #it

    end #end context
  end #end topic iteration
end #end describe

describe "Tech Api: Home Page Blogroll Video Interrupt Playlist Service Call" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/playlists/ign-tech.json?"
    @response = RestClient.get "http://#{@config.options['baseurl']}#{@url}"
    @data = JSON.parse(@response.body)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :prd => true do
    check_200(@response, @data)
  end
  
  it "should not be blank", :prd => true do
    check_not_blank(@response, @data)
  end
  
  it "should return one 'videos' key", :prd => true do
    @data.has_key?('videos').should be_true
  end
  
  it "should return at least 3 vidoes", :prd => true do
    @data['videos'].count.should > 2
  end
  
  it "should return videos with a url key", :prd => true do
    check_key_value_exists_for_all(@response, @data['videos'], 'url')
  end
  
  it "should return videos with a url value containing 'http'", :prd => true do
    @data['videos'].each do |video|
      video['url'].to_s.match('http').should be_true
    end
  end
  
  it "should return videos with thumbnail urls containing 'http'", :prd => true do
    @data['videos'].each do |videos|
      videos['thumbnails'].each do |thumb|
        thumb['url'].match(/http/).should be_true
      end
    end
  end

end

describe "Tech Api: Home Page Blogroll Popular Articles Interrupt Service Call" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
    @url = "/v2/articles.json?post_type=article&sort=popularity&categories=tech&per_page=6"
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
    check_key_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a slug value present", :stg => true do
    check_key_value_exists_for_all(@response, @data, "slug")
  end
  
  it "should return articles with a blogroll headline key", :stg => true do
    check_key_within_key_exists_for_all(@response, @data, 'blogroll', 'headline')
  end
  
  it "should return articles with a blogroll headline value", :stg => true do
    check_value_of_key_within_hash_exists_for_all(@response, @data, 'blogroll', 'headline')
  end
  
  it "should return articles with a category of tech", :stg => true do
    check_key_value_within_array_contains_for_all(@response, @data, "categories", "slug", "tech")
  end
  
  it "should return six articles", :stg => true do
    article_count(@response, @data, 6)
  end
  
  it "should return articles with a publish_date key present", :stg => true do
    check_key_exists_for_all(@response, @data, "publish_date")
  end
  
  it "should return articles with a publish_date value matching yyyy/mm/dd/", :stg => true do
    @data.each do |article|
      article['publish_date'].match(/\A\d\d\d\d-\d\d-\d\dT/).should be_true
    end
  end

end