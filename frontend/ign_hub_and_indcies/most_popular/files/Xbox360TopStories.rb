require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/global_header_module"
require "files/helpers/ign_hubs_indices_module"

class Xbox360TopStories < Test::Unit::TestCase

  include GlobalHeaderMod
  include IGNHubsIndicesMod

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
  
  def test_xbox360_top_stories

    sign_in
	
    # CHECK BASIC ELEMENTS OF XBOX 360 TOP STORIES PAGE
    # Open 360 Top Stories
    @selenium.open "http://xbox360.ign.com/index/features.html"
	global_header("http://xbox360.ign.com/index/features.html")
    # Verify Title
    begin
        assert /^[\s\S]*Xbox 360 News & Updates[\s\S]*$/ =~ @selenium.get_title, "http://xbox360.ign.com/index/features.html not loading or title has changed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "Today's Xbox360 Top Stories" <a> and <a> img src has an "http" path
    begin
        assert @selenium.is_element_present("css=a#hu0[href*=http] img[src*=http]"), "http://xbox360.ign.com/index/features.html 'Todays's Xbox 360 Top Stories' thumbs no <a> or <img>"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=a#hu1[href*=http] img[src*=http]"), "http://xbox360.ign.com/index/features.html 'Todays's Xbox 360 Top Stories' thumbs no <a> or <img>"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=a#hu2[href*=http] img[src*=http]"), "http://xbox360.ign.com/index/features.html 'Todays's Xbox 360 Top Stories' thumbs no <a> or <img>"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=a#hu3[href*=http] img[src*=http]"), "http://xbox360.ign.com/index/features.html 'Todays's Xbox 360 Top Stories' thumbs no <a> or <img>"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=a#hu4[href*=http] img[src*=http]"), "http://xbox360.ign.com/index/features.html 'Todays's Xbox 360 Top Stories' thumbs no <a> or <img>"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify text in (1)title and (2)preview of first 3 blogroll entires
    #      First:
    title1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para h3.hdr")
    if title1.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry no title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    prev1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para div.content-headlines")
    if prev1.length > 27 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry no blurb below title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Second:
    title2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para h3.hdr")
    if title2.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry no title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    prev2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para div.content-headlines")
    if prev2.length > 27 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry no blurb below title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Third:
    title3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para h3.hdr")
    if title3.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry no title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    prev3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para div.content-headlines")
    if prev3.length > 27 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry no blurb below title - http://xbox360.ign.com/index/features.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END END END 
  end
end
