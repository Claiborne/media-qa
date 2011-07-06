require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'files/helpers/events_mod'
require 'files/helpers/global_header_module'

class E3News < Test::Unit::TestCase

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
	puts "::::::::::::E3 NEWS PAGE:::::::::::::"
	puts""
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_news
  
	sign_in
	
	# OPEN PAGE
    @selenium.open "http://www.ign.com/events/e3/2011/news"
	
	global_header("News")
	
	# BLOGROLL TITLE
	# Blogroll title contains "News"
	begin
		assert /^[\s\S]*News[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Unable to verify the News page blogroll title is visible"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	event_banner("News")
	
	event_nav("News")
	
	blogroll_nav("News")
	
	blogroll_iteration("News")
  end
end