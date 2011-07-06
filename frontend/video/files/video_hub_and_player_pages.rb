require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'date'
require 'files/helpers/video_mod'
require 'files/helpers/video_hub_mod'
require 'files/helpers/video_player_page_mod'
require 'files/helpers/global_header_checker'

class VideoHubAndPlayerPages < Test::Unit::TestCase

	include GlobalHeaderChecker
	include VideoMod
	include VideoHubMod
	include VideoPlayerPageMod

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
  
  def test_video_hub_and_player_pages

	sign_in
	
	#CLICK "VIDEOS IN GLOBAL NAV TO OPEN VIDEO HUB
	@selenium.click("css=li#navItem-video a")
	@selenium.wait_for_page_to_load("40")
	
	check_url_is_video_hub
	check_global_header("Video Hub")
	check_three_featured_vids
	check_blogroll_entry_date_is_within_2_days
	
	#CLICK EACH FEATURED VIDEO TO CHECK EACH PLAYER PAGE
	(1..3).each do |i|
		@selenium.click("css=div#video-hub li:nth-child(#{i}) > a")
		@selenium.wait_for_page_to_load("40")

		check_video_player_page

		@selenium.go_back
		@selenium.wait_for_page_to_load("40")
	end
	
	#CLICK FIRST THREE VIDEOS IN BLOGROLL TO CHECK EACH PLAYER PAGE
	(2..4).each do |i|
		@selenium.click("css=div#video-blogroll div:nth-child(#{i}) > div a")
		@selenium.wait_for_page_to_load("40")

		check_video_player_page

		@selenium.go_back
		@selenium.wait_for_page_to_load("40")
	end
	
	check_able_to_populate_blogroll_with_more_entries
	check_still_able_to_populate_more_entries
	check_no_duplicates_in_blogroll
	

	check_blogroll_nav_count_atleast_4(@selenium.get_xpath_count("//div[@id='video-blogroll']/ul/li/a"))
	iterate_through_blogroll_nav_and_check_blogroll_entries
	
	check_right_rail_promoted_video
	check_right_rail_most_recent_series
  end
  
  def check_video_player_page
	check_global_header(@selenium.get_location)
	check_video_title_present
	check_video_player_present
	check_video_player_sub_display_present
	check_must_watch_videos
	check_disqus_comment_box_present
	check_disqus_comments_present
	check_right_rail_promoted_video
	check_right_rail_most_recent_series
	check_right_rail_first_three_related_videos
	check_header_facebook_like_and_tweet_present
	check_footer_more_videos_widget
  end
end