require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class MovieNewsToVideo < Test::Unit::TestCase

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
  
  def test_movie_news_to_video
    # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
    # END SIGN IN
    # CHECK MOVIE NEWS INDEX > NEWS (DEFAULT) TAB > CHECK TITLE AND PREVIEW TEXT
    # Open Movies News index
    @selenium.open "http://movies.ign.com/index/news.html"
    # Assert on Movies News page
    assert /^[\s\S]*IGN Movies:[\s\S]*$/ =~ @selenium.get_title
    # Assert "News" tab selected
    assert @selenium.is_element_present("css=ul#left-col-consoles a[href=\"/index/news.html\"][class=\"filter-js filter selected\"]")
    # Verify first 3 titles string > 0
    #      First title:
    title1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para strong")
 	if title1.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry in blogroll may not have a title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Second title:
    title2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para strong")
    if title2.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry in blogroll may not have a title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Third title:
    title3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para strong")
    if title3.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry in blogroll may not have a title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify first 3 entry-previews have string > 27
    #      First para:
    para1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para div.content-headlines")
    if para1.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Second para:
    para2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para div.content-headlines")
	if para2.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Third para:
    para3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para div.content-headlines")
    if para3.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/news.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END END END
    # CHECK MOVIE NEWS INDEX -- VIDEO TAB
    # Assert on Movies News page
    assert /^[\s\S]*IGN Movies:[\s\S]*$/ =~ @selenium.get_title
    # Click over to "Video" tab
    @selenium.open "http://movies.ign.com/index/video.html"
    # Assert/Wait for Video content to populate 
	@selenium.wait_for_page_to_load "30000"
    # Verify first 3 titles string > 0
    #      First title:
    title1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para a")
    if title1.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry in blogroll may not have a title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Second title:
    title2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para a")
    if title2.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry in blogroll may not have a title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Third title:
    title3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para a")
    if title3.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry in blogroll may not have a title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify first 3 entry-previews have string > 27
    #      First para:
    para1 = @selenium.get_text("css=div#all-news div.headlines div.txt-para div.content-headlines")
    if para1.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Second para:
    para2 = @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para div.content-headlines")
    if para2.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #      Third para:
    para3 = @selenium.get_text("css=div#all-news div:nth-child(3).headlines div.txt-para div.content-headlines")
    if para3.length > 27 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry in blogroll may not have a blurb under the title - http://movies.ign.com/index/video.html"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END END END
  end
end
