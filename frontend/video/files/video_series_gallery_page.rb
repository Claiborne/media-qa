require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/helpers/video_mod'
require 'files/helpers/global_header_checker'
require 'files/helpers/video_series_gallery_page_mod'

class VideoSeriesGalleryPage < Test::Unit::TestCase

	include GlobalHeaderChecker
	include VideoMod
	include VideoSeriesGalleryPageMod
	
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
	  :host => "qa-server",
      :port => 4444,
	  :browser => "Firefox on Windows",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_video_series_gallery_page_daily_fix
	video_series_gallery_page_daily_fix("http://www.ign.com/videos/series/ign-daily-fix")
  end
  
  #def test_video_series_gallery_page_strategize
	#video_series_gallery_page_strategize("http://www.ign.com/videos/series/ign-strategize")
  #end
  
  #def test_video_series_gallery_page_ign_game_reviews
	#video_series_gallery_page_ign_game_reviews("http://www.ign.com/videos/series/ign-game-reviews")
  #end
  
  def video_series_gallery_page_daily_fix(page)
	sign_in
	
	#OPEN SERIES GALLERY/INDEX
	@selenium.open(page)

	check_global_header("Daily Fix Index")
	check_banner
	
	check_able_to_populate_blogroll_with_more_entries
	check_still_able_to_populate_more_entries
	check_no_duplicates_in_blogroll
	
	iterate_through_blogroll_nav_and_check_blogroll_entries
	
	check_most_popular_videos_top_widget
	check_right_rail_most_recent_series
	check_right_rail_promoted_video
	check_footer_more_videos_widget
	check_right_rail_facebook_like_and_tweet_present
  end
  
  def video_series_gallery_page_strategize(page)
	sign_in
	
	#OPEN SERIES GALLERY/INDEX
	@selenium.open(page)

	check_global_header("Strategize Index")
	check_banner
	
	check_able_to_populate_blogroll_with_more_entries
	check_still_able_to_populate_more_entries
	check_no_duplicates_in_blogroll
	
	iterate_through_blogroll_nav_and_check_blogroll_entries
	
	check_most_popular_videos_top_widget
	check_right_rail_most_recent_series
	check_right_rail_promoted_video
	check_footer_more_videos_widget
	check_right_rail_facebook_like_and_tweet_present
  end
  
  def video_series_gallery_page_ign_game_reviews(page)
	sign_in
	
	#OPEN SERIES GALLERY/INDEX
	@selenium.open(page)

	check_global_header("Daily Fix Index")
	check_banner
	
	check_able_to_populate_blogroll_with_more_entries
	check_still_able_to_populate_more_entries
	check_no_duplicates_in_blogroll
	
	iterate_through_blogroll_nav_and_check_blogroll_entries
	
	check_most_popular_videos_top_widget
	check_right_rail_most_recent_series
	check_right_rail_promoted_video
	check_footer_more_videos_widget
	check_right_rail_facebook_like_and_tweet_present
  end
end