require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'files/helpers/events_mod'
require 'files/helpers/global_header_module'

class E3Main < Test::Unit::TestCase

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
	puts ":::::::::E3 MAIN/ESSENTAILS PAGE:::::::::"
	puts""
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_main
  
	sign_in
	
	# OPEN PAGE
    @selenium.open "/e3"
	
	# QUICK HACK TO HAVE BLOG INTERRUPT NOT BREAK THIS SUITE
	@selenium.click("css=ul.ign-blogrollFilters li:nth-child(2) > a")
	sleep 4
	@selenium.click("css=ul.ign-blogrollFilters li a")
	sleep 3
	
	global_header("Essentials/Hub")
	
	# VERIFY TITLE
    begin
        assert /^[\s\S]*E3 2011[\s\S]*$/ =~ @selenium.get_title, "Unable to verify E3 site title contains 'E3 2011'."
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	event_banner("Essentials/Hub")
	
	event_nav("Essentials/Hub")
	
	# HERO BOX MAIN (left portion)
    # For each five displays: a href & img src = http
	for i1 in 0..5 do
		begin
			assert @selenium.is_element_present("css=div[class='storyUnit cvr-display_"+i1.to_s+"'] div.cvr-main a[href*='http'] img[src*='http']") || @selenium.is_element_present("css=div[class='storyUnit cvr-display_"+i1.to_s+"'] div.cvr-main a[onclick*='IGN.HeroUnit'] img[src*='http']"), "Unable to verify the "+i1.to_s+" positioned feature in the Hero Box display is funtioning properly. It might not be linking to anywhere, or might have not display"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end

	# HERO BOX HIGHLIGHTS (right portion)
    # For each check title contains string; sting > 0
	for i2 in 0..4 do
		# For each verify element present:
		begin
			assert @selenium.is_element_present("css=div[class='storyUnit cvr-display_"+i2.to_s+"'] div.cvr-highlights div.cvr-highlightsTitle"), "Unable to verify the right portion highlights of the "+i2.to_s+" positioned feature in the Hero Box is dsiplaying"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		# For each get string
		text =""
		bool =""
		text = @selenium.get_text("css=div[class='storyUnit cvr-display_"+i2.to_s+"'] div.cvr-highlights div.cvr-highlightsTitle")
		if text.length > 0 then bool = "true" 
		else bool = ""
		end
		# For each assert string > 0
		begin
			assert_equal "true", bool, "Unable to verify the right portion highlights of the "+i2.to_s+" positioned feature in the Hero Box is displaying a title"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	# HERO THUMBS
    # a href & img src = http
	for i3 in 1..5 do
		begin
			assert @selenium.is_element_present("//ul[@class='cvr-thumbs']/li["+i3.to_s+"]/a[contains(@href,'http')]/img[contains(@src,'http')]") || @selenium.is_element_present("//ul[@class='cvr-thumbs']/li["+i3.to_s+"]/a[contains(@onclick,'IGN.HeroUnit')]/img[contains(@src,'http')]"), "Unable to verify the "+i3.to_s+" positioned hero thumb is displaying and links to another page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	# BLOGROLL TITLE
	# Blogroll title contains "Top Stories"
	begin
		assert /^[\s\S]*Top Stories[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Unable to verify the Essentials/Hub page has a blogroll title 'E3 2011 Latest Top Stories'"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	blogroll_nav("Essentials/Main")
	
	blogroll_iteration("Essentials/Hub")
	
  end
end

	