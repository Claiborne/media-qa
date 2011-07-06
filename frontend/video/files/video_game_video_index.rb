require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'date'
require 'files/helpers/video_mod'
require 'files/helpers/video_game_video_index_mod'
require 'files/helpers/global_header_checker'

class VideoGameVideoIndex < Test::Unit::TestCase

	include GlobalHeaderChecker
	include VideoMod
	include VideoGameVideoIndexMod

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
  
  def test_video_game_video_index

	sign_in
	
	#OPEN GAME VIDEO INDEX
	game_vid_index = "http://www.ign.com/videos/games/batman-arkham-asylum-xbox-360-14273491"
	@selenium.open(game_vid_index)
	
	check_global_header(game_vid_index)
	check_game_header(game_vid_index)
	check_game_nav(game_vid_index)
	check_most_popular_videos_top_widget
	iterate_through_blogroll_nav_and_check_blogroll_entries_on_game_video_index(game_vid_index)
	check_right_rail_game_details(game_vid_index)	
	check_right_rail_facebook_like_and_tweet_present
	check_footer_more_videos_widget
  end
end