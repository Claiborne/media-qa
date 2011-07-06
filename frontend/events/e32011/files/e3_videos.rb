require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'files/helpers/events_mod'
require 'files/helpers/global_header_module'

class E3Videos < Test::Unit::TestCase

  include EventsMod
  include GlobalHeaderMod
  
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/events/",
      :timeout_in_second => 60
	  
    @selenium.start_new_browser_session
	puts ":::::::::::::E3 VIDEOS PAGE:::::::::::::"
	puts""
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_videos
  
	sign_in
	
	# OPEN PAGE
    @selenium.open "http://www.ign.com/events/e3/2011/videos"
	
	global_header("Vidoes")
	
	# BLOGROLL TITLE
	# Blogroll title contains "Videos"
	begin
		assert /^[\s\S]*Videos[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Unable to verify the Videos page blogroll title is visible"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	event_banner("Videos")
	
	event_nav("Videos")
	
	blogroll_nav("Videos")
	
	blogroll_iteration("Videos")
  end
end