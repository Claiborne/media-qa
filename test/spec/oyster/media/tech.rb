require 'rspec'
require 'configuration'
require 'nokogiri'
require 'open-uri'
require 'tech_nav'
require 'rest_client'
require 'json'
require 'ads'
require 'open_page'
require 'widget/blogroll_v2_articles'
require 'widget/discover_more'
require 'widget/cover_stories_main'
require 'widget/cover_stories_extra'
require 'widget/tag_cover_stories'
require 'widget/vert_nav'
require 'widget/wiki_updates'

include OpenPage
include VertNav
include CoverStoriesMain
include CoverStoriesExtra
include TagCoverStories
include TechNav
include Blogrollv2Articles
include DiscoverMore
include Ads
include WikiUpdates

describe "tech frontend - home page" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should have at least one css file", :stg => true, :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end

  it "should not have any css files that return 400 or 500", :stg => true do
    @doc.css("link[@href*='.css']").each do |css|
      response = RestClient.get css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end 

  it "should not be missing the global header widget", :stg => true, :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true, :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  context "main cover-stories widget" do
    
    widget_cover_stories_main
    
  end
  
  context "extra cover-stories widget" do
    
    widget_cover_stories_extra
    
  end

  context "blogroll widget" do

    widget_blogroll_v2_articles(10, "/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
    
  end
  

  context "discover more widget" do
  
    widget_discover_more

  end

  context "ads" do
  
    ads_on_tech_page
  
  end

end

@topic = return_tech_nav
@topic.each do |topic|
  
describe "tech frontend - #{topic} tag page" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech/#{topic}"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should have at least one css file", :stg => true, :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end
  
  it "should not have any css files that return 400 or 500", :stg => true do
    @doc.css("link[@href*='.css']").each do |css|
      response = RestClient.get css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end     
  
  it "should not be missing the global header widget", :stg => true, :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true, :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end

  context "blogroll widget" do
  
    widget_blogroll_v2_articles(20, "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&sort=publish_date&order=desc")
  
  end 
  
  context "vertical navigation widget" do
    
    widget_vert_nav("tech", topic)
  
  end
  
  context "tag cover stories widget" do
    
    widget_tag_cover_stories
  
  end
  
  context "discover more widget" do
  
    widget_discover_more

  end
  
  context "Wiki Updates Widget" do
    
    widget_wiki_updates
    
  end

  context "ads" do
  
    ads_on_tech_page
  
  end

end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/09/21/gears-of-war-3-dolby-7-1-surround-sound-headset-review"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should have at least one css file", :stg => true, :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end
  
  it "should not have any css files that return 400 or 500", :stg => true do
    @doc.css("link[@href*='.css']").each do |css|
      response = RestClient.get css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end  
  
  it "should not be missing the global header widget", :stg => true, :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true, :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  it "should not be missing the two share this widgets", :stg => true, :code => true do
    (@doc.css("div[class*='shareThis addthis_toolbox']").count == 2).should be_true

  end
  
  it "should not be missing the discus comments widget", :stg => true, :code => true do
    @doc.at_css('div#disqus_thread').should be_true
  end
  
  it "should not be missing the pagination widget when more than one page exists", :stg => true, :code => true do
    @doc.at_css('div.pager_list').should be_true
  end
  
  it "should not display the pagination widget when only one page exists", :stg => true do
    Nokogiri::HTML(open("http://#{@config.options['baseurl']}/articles/2011/08/24/report-iphone-5-coming-to-sprint")).at_css('div.pager_list').should be_false
  end

  context "ads" do
  
    ads_on_v2_article
  
  end
end


