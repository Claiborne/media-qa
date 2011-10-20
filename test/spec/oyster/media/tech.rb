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
require 'widget/video_interrupt'
require 'widget/popular_articles_interrupt'

include PopularArticlesInterrupt
include VideoInterrupt
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

describe "Tech HomePage:" do

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
  
  it "should not return 400 or 500", :code => true do
    @doc
  end

  it "should have at least one css file", :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end

  it "should not have any css files that return 400 or 500" do
    @doc.css("link[@href*='.css']").each do |css|
      response = rest_client_open css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end 

  it "should not be missing the global header widget", :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  context "Tech Nav (Discover More Expanded) Widget" do
    wiget_discover_more_expanded
  end
  
  context "Main Cover Stories Widget:" do
    widget_cover_stories_main
  end
  
  context "Extra Cover Stories Widget:" do
    widget_cover_stories_extra
  end

  context "Blogroll Widget:" do
    widget_blogroll_v2_articles(10, "/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
  end
  
  context "Video Interrupt Widget:" do
    widget_video_interrupt
  end
  
  context "Popular Article Interrupt Widget:" do
    widget_popular_articles_interrupt
  end

  #context "Ads" do
    #ads_on_tech_page
  #end

end

@topic = return_tech_nav
@topic.each do |topic|
  
describe "Tech #{topic} Topic Page:" do

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
  
  it "should not return 400 or 500", :code => true do
    @doc
  end

  it "should have at least one css file", :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end
  
  it "should not have any css files that return 400 or 500" do
    @doc.css("link[@href*='.css']").each do |css|
      response = rest_client_open css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end     
  
  it "should not be missing the global header widget", :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end

  context "Blogroll Widget:" do
    widget_blogroll_v2_articles(20, "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&sort=publish_date&order=desc")
  end 
  
  context "Vertical Navigation Widget:" do
    widget_vert_nav("tech", topic)
  end
  
  context "Tag Cover Stories Widget:" do
   widget_tag_cover_stories
  end
  
  context "Discover More Widget:" do
    widget_discover_more
  end
  
  if topic != 'lifestyle'
    context "Wiki Updates Widget:" do
      widget_wiki_updates
    end
  end

  #context "Ads" do
    #ads_on_tech_page
  #end

end
end

describe "Tech v2 Article Page:" do
  
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
  
  it "should not return 400 or 500", :code => true do
    @doc
  end

  it "should have at least one css file", :code => true do
    @doc.css("head link[@href*='.css']").count.should > 0
  end
  
  it "should not have any css files that return 400 or 500" do
    @doc.css("link[@href*='.css']").each do |css|
      response = rest_client_open css.attribute('href').to_s
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end  
  
  it "should not be missing the global header widget", :code => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :code => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  it "should not be missing the two share this widgets", :code => true do
    (@doc.css("div[class*='shareThis addthis_toolbox']").count == 2).should be_true

  end
  
  it "should not be missing the discus comments widget", :code => true do
    @doc.at_css('div#disqus_thread').should be_true
  end
  
  it "should not be missing the pagination widget when more than one page exists"#, :code => true do
   #@doc.at_css('div.pager_list').should be_true
  #end
  
  it "should not be missing the tech vertical navigation", :code => true do
    
  end
  
  it "should not display the pagination widget when only one page exists" do
    Nokogiri::HTML(open("http://#{@config.options['baseurl']}/articles/2011/08/24/report-iphone-5-coming-to-sprint")).at_css('div.pager_list').should be_false
  end
  
  it "should display the discover more widget" do
    @doc.at_css('div.slider-holder div.slider').should be_true
  end
  
  context "Vert Nav Widget" do
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.vn-container ul li').should be_true
    end
    
    it "should display all components", :code => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      @doc.css('div.vn-container ul li.vn-navItem a').count.should > 3
    end
  end
  

  #context "Ads:" do
    #ads_on_v2_article
  #end
end


