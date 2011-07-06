require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/helpers/video_mod'
require 'files/helpers/global_header_checker'
require 'files/helpers/video_series_index_mod'

class VideoSeriesIndex < Test::Unit::TestCase

	include GlobalHeaderChecker
	include VideoMod
	include VideoSeriesIndexMod

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
  
  def test_video_series_index

	sign_in
	
	#OPEN SERIES INDEX
	@selenium.open("http://www.ign.com/videos/series")
	
	check_global_header("Video Series Index")
	check_most_popular_videos_top_widget
	check_blogroll
	check_blogroll_when_sort_by_most_recent_videos
	check_populate_more_blogroll_button
	check_right_rail_most_recent_series
	check_right_rail_promoted_video
	check_footer_more_videos_widget
	check_right_rail_facebook_like_and_tweet_present
  end
end