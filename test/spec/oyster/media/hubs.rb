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

@hubs = return_hubs_list

@hubs.each do |hub|
  
describe "Oyster Hubs: Tech"
  
describe "Oyster Hubs: #{hub}" do

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
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end     
  
  context "Global Header Widget" do
    widget_global_header
  end
  
  context "Global Footer Widget" do
    widget_global_footer
  end
  
  context "Cover Stories Widget" do
    widget_cover_stories_hub
  end
  
  context "Blogroll" do
    widget_legacy_blogroll
  end
  

  if (hub.match(/movies.ign.com/) || 
    hub.match(/comics.ign.com/) || 
    hub.match(/tv.ign.com/) || 
    hub.match(/stars.ign.com/) ||
    hub.match(/music.ign.com/) ||
    hub.match(/wireless.ign.com/))
    
  elsif (hub.match(/www.ign.com/) || 
    hub.match(/uk.ign.com/) || 
    hub.match(/au.ign.com/))
  
    context "Entertainment Promo Widget" do
      widget_ent_promo
    end
  
    context "Top Games Out Now Content View" do
      widget_top_games('out_now')
    end
    
    context "Top Games Coming Soon Content View" do
      widget_top_games('comming_soon')
    end
    
    context "Discover More Widget" do
      widget_discover_more
    end

    context "What We're Playing Widget" do
      widget_what_we_are_playing
    end
    
    context "IGN Essentials (Promo) Widget" do
      widget_promo('essentials')
    end

    context "Hot Reviews Widget" do
      widget_hot_reviews_previews('reviews')
    end

    context "Hot Preview Widget" do
      widget_hot_reviews_previews('previews')
    end

    context "Hot Game Help Widget" do
      widget_hot_reviews_previews('game-help')
    end

    context "IGN Friends (Promo) Widget" do
      widget_promo('ignfriends')
    end

    context "Promotions and Sweepstakes (Promo) Widget" do
      widget_promo('promotions')
    end

    context "Around the Network (Promo) Widget" do
      widget_promo('aroundthenetwork')
    end

  else

    context "Entertainment Promo Widget" do
      widget_ent_promo
    end
      
    context "Top Games Out Now Content View" do
      it "should be on the page once", :smoke => true do
        @doc.css('div#right-col-outnow-tabs').count.should == 1
      end
    
      it "should display text", :smoke => true do
        check_display_text('div#right-col-outnow-tabs')
      end

      it "should have at least one link", :smoke => true do
        check_have_a_link('div#right-col-outnow-tabs')
      end
    end
    
    context "Top Games Coming Soon Content View" do
      it "should be on the page once", :smoke => true do
        @doc.css('div#right-col-comingsoon-tabs').count.should == 1
      end
    
      it "should display text", :smoke => true do
        check_display_text('div#right-col-comingsoon-tabs')
      end

      it "should have at least one link", :smoke => true do
        check_have_a_link('div#right-col-comingsoon-tabs')
      end
    end
    
    context "Discover More Widget" do
      widget_discover_more
    end
    
    context "IGN Essentials (Promo) Widget" do
      widget_promo('essentials')
    end

    context "Hot Reviews Widget" do
      widget_hot_reviews_previews('reviews')
    end

    context "Hot Preview Widget" do
      widget_hot_reviews_previews('previews')
    end

    context "Hot Game Help Widget" do
      widget_hot_reviews_previews('game-help')
    end
    
    context "Hot News Widget" do
      widget_hot_reviews_previews('hot-news')
    end

    context "IGN Friends (Promo) Widget" do
      widget_promo('ignfriends')
    end

    context "Promotions and Sweepstakes (Promo) Widget" do
      widget_promo('promotions')
    end

    context "Around the Network (Promo) Widget" do
      widget_promo('aroundthenetwork')
    end
  
  end#end if else
  
end# end describe
end# end hub interation
