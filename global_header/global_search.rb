require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class SearchSmoke < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_blog_new_post
  
	# SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
	
	@selenium.open "/"
	@selenium.wait_for_page_to_load "30000"
	
    @selenium.type "search-global", "metal gear solid"
    @selenium.click "search-submit"
    @selenium.wait_for_page_to_load "30000"
	
	begin
        assert @selenium.is_element_present("css=input#search-global"), "The search input box appears missing from the global header"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
    begin
        assert_equal "Search Results for \"metal gear solid\" - IGN", @selenium.get_title, "The title of the search results page does not match; possible sanity failure"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div div.game-info h3 a[href*='http']"), "On the results page, 'Product' tab -- the first entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(2) > div.game-info h3 a[href*='http']"), "On the results page, 'Product' tab -- the second entry is not linked"
	rescue
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(3) > div.game-info h3 a[href*='http']"), "On the results page, 'Product' tab -- the third entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    @selenium.click "css=ul#tab-blogroll li:nth-child(2) > a"
    assert !60.times{ break if (@selenium.is_element_present("css=div#searchResults div.video-result") rescue false); sleep 1 }
    begin
	
        assert @selenium.is_element_present("css=div#searchResults div div.video-info a[href*='http']"), "On the results page, 'Video' tab -- the first entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(2) > div.video-info a[href*='http']"), "On the results page, 'Video' tab -- the second entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(3) > div.video-info a[href*='http']"), "On the results page, 'Video' tab -- the third entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    @selenium.click "css=ul#tab-blogroll li:nth-child(4) > a"
    assert !60.times{ break if (@selenium.is_element_present("css=div#searchResults div.article-result") rescue false); sleep 1 }
	
    begin
        assert @selenium.is_element_present("css=div#searchResults div h3 a[href*='http']"), "On the results page, 'Article' tab -- the first entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(2) > h3 a[href*='http']"), "On the results page, 'Article' tab -- the second entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=div#searchResults div:nth-child(3) > h3 a[href*='http']"), "On the results page, 'Article' tab -- the third entry is not linked"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
  end
end
