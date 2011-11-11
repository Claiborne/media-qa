require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'files/helpers/events_mod'
require 'files/helpers/global_header_module'

class E3Images < Test::Unit::TestCase

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
	puts ":::::::::::::E3 IMAGES PAGE:::::::::::::"
	puts""
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_images
  
	sign_in
	
	# OPEN PAGE
    @selenium.open "http://www.ign.com/events/e3/2011/images"
	
	global_header("Images")
	
	# BLOGROLL TITLE
	# Blogroll title contains "Images"
	begin
		assert /^[\s\S]*Images[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Unable to verify the Images page blogroll title is visible"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	event_banner("Images")
	
	event_nav("Images")
	
	blogroll_nav("Images")
	
    blogroll_iteration("Images")
  end
end