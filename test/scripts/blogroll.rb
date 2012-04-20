require 'rspec'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'hubs_list'
require 'widget/global_header'
require 'widget/global_footer'
require 'widget/cover_stories_hub'
require 'widget/legacy_blogroll'
require 'widget/ent_promo'
require 'widget/discover_more'
require 'widget/top_games'
require 'widget/what_we_are_playing'
require 'widget/promo'
require 'widget/hot_reviews_previews'
require 'widget/youtube_start_schedule'

include YoutubeStartSchedule
include HotReviewsPreviews
include Promo
include WhatWeArePlaying
include TopGames
include DiscoverMore
include EntPromo
include LegacyBlogroll
include CoverStoriesHub
include HubsList
include FeChecker
include OpenPage
include GlobalFooter
include GlobalHeader

# wii-u only stuff
require 'widget/evo_header'
require 'widget/cover_stories_main'

include EvoHeader
include CoverStoriesMain

# blogroll
require 'widget/blogroll_v3_articles'
include Blogrollv3Articles

@hubs = return_hubs_list

@hubs.each do |hub|
  
describe "Oyster Hubs -- #{hub}" do

  before(:all) do
    @page = hub.to_s
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
  
  context "v3 blogroll" do
    widget_blogroll_v3_articles(10,'n/a')
  end
  
end
end