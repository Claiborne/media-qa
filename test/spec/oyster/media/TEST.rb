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
  context "Ads" do
    ads_on_tech_page
  end
end

#@topic = return_tech_nav
@topic = ['ipad']
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
  context "Ads" do
    ads_on_tech_page
  end
end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/10/04/whats-new-about-the-iphone-4s"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  context "Ads" do
    ads_on_v2_article
  end

end


