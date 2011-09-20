require 'rspec'
require 'configuration'
require 'Nokogiri'
require 'open-uri'
require 'tech_nav'
require 'widget/blogroll_v2_articles'
require 'widget/discover_more'
require 'rest_client'
require 'json'

include TechNav
include Blogrollv2Articles
include DiscoverMore

describe "tech frontend - link checker" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end

describe "tech frontend - tech home page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  context "blogroll widget" do
  
    it "should not be missing from the page", :stg => true do
      widget_blogroll_v2_articles_check_not_missing(@doc)
    end
  
    it "should be 10 blogroll entries", :stg => true do
      widget_blogroll_v2_articles_check_num_entries(@doc, 10)
    end
  
    it "shoud display author name", :stg => true do
      widget_blogroll_v2_articles_check_author_name(@doc, 10)
    end
    
    it "shoud display timestamp", :stg => true do
      widget_blogroll_v2_articles_check_timestamp(@doc, 10)
    end
    
    it "shoud display comments link", :stg => true do
      widget_blogroll_v2_articles_check_comments_link(@doc, 10)
    end
    
    it "shoud display headline", :stg => true do
      widget_blogroll_v2_articles_check_headline(@doc, 10)
    end
    
    it "shoud display article summary", :stg => true do
      widget_blogroll_v2_articles_check_article_summary(@doc, 10)
    end
    
    it "shoud display read more link in article summary", :stg => true do
      widget_blogroll_v2_articles_check_read_more(@doc, 10)
    end
    
    it "should display the same articles as the api returns" do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v2.yml"
      config = Configuration.new
    
      widget_blogroll_v2_articles_check_matches_article_api(@doc, 10, "http://#{config.options['baseurl']}/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
    end
  end  
  
  context "discover more widget" do
  
    it "should not be missing from the page", :stg => true do
      widget_discover_more_check_not_missing(@doc)
    end
    
    it "should display a title", :stg => true do
      widget_discover_more_check_title(@doc)
    end
    
    it "should display an non-broken image", :stg => true do
      widget_discover_more_check_img_not_400_or_500(@doc)
    end
    
    it "should have next and prev links that are not 400 or 500", :stg => true do
      widget_discover_more_check_next_and_prev_links_not_400_or_500(@doc)
    end
    
    it "should display text links to articles", :stg => true do
      widget_discover_more_check_article_links(@doc)
    end
    
    it "should display text links to articles that are not 400 or 500", :stg => true do
      widget_discover_more_check_article_links_not_400_or_500(@doc)
    end
    
    it "should link to a category or topic page that is not 400 or 500", :stg => true do
      widget_discover_more_check_news_and_updates_link_not_400_or_500(@doc)
    end
  end
end

@topic = return_tech_nav
@topic.each do |topic|
describe "tech frontend - tech/#{topic} page" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech/#{topic}"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  context "blogroll widget" do
  
    it "should not be missing", :stg => true do
      widget_blogroll_v2_articles_check_not_missing(@doc)
    end  
  
    it "should be 20 blogroll entries", :stg => true do
      widget_blogroll_v2_articles_check_num_entries(@doc, 20)
    end
  
    it "shoud display author name", :stg => true do
      widget_blogroll_v2_articles_check_author_name(@doc, 20)
    end
    
    it "shoud display timestamp", :stg => true do
      widget_blogroll_v2_articles_check_timestamp(@doc, 20)
    end
    
    it "shoud display comments link", :stg => true do
      widget_blogroll_v2_articles_check_comments_link(@doc, 20)
    end
    
    it "shoud display headline", :stg => true do
      widget_blogroll_v2_articles_check_headline(@doc, 20)
    end
    
    it "shoud display article summary", :stg => true do
      widget_blogroll_v2_articles_check_article_summary(@doc, 20)
    end
    
    it "shoud display read more link in article summary", :stg => true do
      widget_blogroll_v2_articles_check_read_more(@doc, 20)
    end
    
    it "should display the same articles as the api returns" do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v2.yml"
      config = Configuration.new
    
      widget_blogroll_v2_articles_check_matches_article_api(@doc, 20, "http://#{config.options['baseurl']}/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&sort=publish_date&order=desc")
    end
  end  
end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/09/13/article-test-page-sept-2011"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  it "should not be missing the two share this widgets", :stg => true do
    (@doc.css("div[class*='shareThis addthis_toolbox']").count == 2).should be_true

  end
  
  it "should not be missing the discus comments widget", :stg => true do
    @doc.at_css('div#disqus_thread').should be_true
  end
  
  it "should not be missing the pagination widget when more than one page exists", :stg => true do
    @doc.at_css('div.pager_list').should be_true
  end
  
  it "should not display the pagination widget when only one page exists", :stg => true do
    Nokogiri::HTML(open("http://#{@config.options['baseurl']}/articles/2011/08/24/report-iphone-5-coming-to-sprint")).at_css('div.pager_list').should be_false
  end
end
=end