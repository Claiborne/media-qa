require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'hubs_list'
require 'widget/evo_header'
require 'widget/global_footer'
require 'widget/cover_stories_main'
require 'widget/cover_stories_extra'
require 'widget/top_games'
require 'widget/most_commented_stories'
require 'widget/video_interrupt'
require 'widget/popular_threads'
require 'widget/blogroll_v3_articles'

include Blogrollv3Articles
include OpenPage
include FeChecker
include HubsList
include EvoHeader
include GlobalFooter
include TopGames
include CoverStoriesMain
include CoverStoriesExtra
include MostCommentedStories
include VideoInterrupt
include PopularThreads

describe "Oyster Hubs -- www.ign.com/tech" do
  
  before(:all) do
    #Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_hubs.yml"
    #@config = Configuration.new
    #@page = "http://#{@config.options['baseurl']}#{hub}"
    @page = "http://www.ign.com/tech"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  context "v3 Blogroll widget" do
    widget_blogroll_v3_articles(10, "n/a")
    widget_blogroll_v3_articles_vs_api(10, "tech", "us")
  end

end #end describe

describe "Oyster Hubs -- www.ign.com/wii-u" do
  
  before(:all) do
    #Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_hubs.yml"
    #@config = Configuration.new
    #@page = "http://#{@config.options['baseurl']}#{hub}"
    @page = "http://www.ign.com/wii-u"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  context "Global Header Widget" do
    widget_evo_header
  end
    
  context "Global Footer Widget" do
    widget_global_footer
  end
  
  context "Cover Stories Widget" do
    widget_cover_stories_main_new(5)
  end
  
  context "v3 Blogroll widget" do
    widget_blogroll_v3_articles(10, "n/a")
    widget_blogroll_v3_articles_vs_api(10, "wii", "us")
  end
  
  context "Extra Cover Stories Widget" do
    widget_cover_stories_extra
  end
  
  context "Popular Videos Widget" do
    widget_video_interrupt
  end
  
  context "Most Commented Stories Widget" do
    widget_most_commented_stories
  end
  
  context "Top Games Out Now Widget" do
    widget_top_games('Games Out Now', 5)
  end
  
  context "Top Games Coming Soon Widget" do
    widget_top_games('Games Coming Soon', 5)
  end
  
  context "Popular Threads Widget" do
    widget_popular_threads
  end

end #end describe

######################################################################

@hubs = return_list_of_game_hubs

@hubs.each do |hub|

describe "Oyster Hubs -- #{hub}", :stg => true do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_hubs.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}#{hub}" 
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  context "Global Header Widget" do
    it "should implement..."
  end
    
  context "Global Footer Widget" do
    widget_global_footer
  end
  
  context "Cover Stories Widget" do
    widget_cover_stories_main_new(5)
  end
  
  context "Top Games Out Now Widget" do
    widget_top_games('Games Out Now', 4)
  end
  
  context "Top Games Coming Soon Widget" do
    widget_top_games('Games Coming Soon', 4)
  end

end #end describe
end #end hub iteration

######################################################################

@hubs = return_list_of_non_game_hubs

@hubs.each do |hub|

describe "Oyster Hubs -- #{hub}", :stg => true do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_hubs.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}#{hub}" 
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
end #end describe
end #end hub iteration