require 'rspec'
require 'configuration'
require 'Nokogiri'
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

include VertNav
include CoverStoriesMain
include CoverStoriesExtra
include TagCoverStories
include TechNav
include Blogrollv2Articles
include DiscoverMore
include Ads

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
  
  context "extra cover-stories widget" do
  
    widget_cover_stories_extra
  
  end

end

@topic = return_tech_nav
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
  

end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/09/21/gears-of-war-3-dolby-7-1-surround-sound-headset-review"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end

end


