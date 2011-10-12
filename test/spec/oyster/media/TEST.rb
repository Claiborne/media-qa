require 'rspec'
require 'configuration'
require 'nokogiri'
require 'open-uri'
require 'tech_nav'
require 'rest_client'
require 'json'
require 'ads'
require 'widget/blogroll_v2_articles'
require 'widget/discover_more'
require 'widget/cover_stories_main'
require 'widget/cover_stories_extra'
require 'widget/tag_cover_stories'
require 'widget/vert_nav'
require 'widget/wiki_updates'

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
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  

end

#@topic = return_tech_nav
@topic = ['wii-u']
@topic.each do |topic|
  
describe "tech frontend - #{topic} tag page" do

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
  
  context "Wiki Updates Widget" do
    
    widget_wiki_updates
    
  end
  
end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/10/04/whats-new-about-the-iphone-4s"
    @doc = Nokogiri::HTML(open(@page))
#
#
#
#
#    
    @doc = Nokogiri::HTML(open("http://tech.stg.www.ign.com/articles/2011/10/04/whats-new-about-the-iphone-4s"))
  end

  before(:each) do
    
  end

  after(:each) do

  end

end


