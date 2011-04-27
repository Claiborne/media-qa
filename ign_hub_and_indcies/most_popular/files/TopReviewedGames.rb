require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class TopReviewedGames < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/",
      :timeout_in_second => 30

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_top_reviewed_games
    # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
    # END SIGN IN
    # CHECKS TOP REVIEWED GAMES PAGE AND TOP LINKS (DEFAULT SORT-- DATE) NOT 404
    # Open Reviews Page
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Verify on Reviews index page
    begin
        assert /^[\s\S]*Recently Reviewed Games[\s\S]*$/ =~ @selenium.get_title, "http://www.ign.com/index/reviews.html did not load or title has changed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Open 1st game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(2).game-row td.up-com div.gameShortCuts a"), "'Review' text not present on first game review entry in main review index"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(2).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "First review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "First review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Back to Reviews
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Open 2nd game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(3).game-row td.up-com div.gameShortCuts a"), "'Review' text not present on second game review entry in main review index"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(3).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "Second review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "Second review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Back to Reviews
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Open 3rd game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(4).game-row td.up-com div.gameShortCuts a"), "'Review' text not present on first game review entry in main review index"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(4).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "First review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "Third review entry doesn't lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END END END
    # CHECKS TOP REVIEWED GAMES PAGE AND TOP LINKS (SORT EDITORS CHOICE) NOT 404
    # Open Reviews Index
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Sort by Editor's Choice
    @selenium.click("css=div#tab-blogroll a[href*=\"editorsChoice\"]")
    # Wait for sorted to populate
    assert !60.times{ break if (@selenium.is_element_present("css=div#tab-blogroll div:nth-child(2).selected") rescue false); sleep 1 }
    # Verify on Reviews index page
    begin
        assert /^[\s\S]*Recently Reviewed Games[\s\S]*$/ =~ @selenium.get_title, "Review index did not load when sorted by Editor's Choice, or title has changed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "Editor's Choice" text appears above review score
    begin
        assert_equal "EDITORS' CHOICE", @selenium.get_text("css=span.editors"), "'Editor's Choice text does not appear above review score"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # ==================
    # Open 1st game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(2).game-row td.up-com div.gameShortCuts a"), "'Reviews' text or <a> does not display in the first entry when reviews are sorted by editor's choice"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(2).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "First entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "First entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Back to Reviews Index
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Sort by Editor's Choice
    @selenium.click("css=div#tab-blogroll a[href*=\"editorsChoice\"]")
    # Wait for sorted to populate
    assert !60.times{ break if (@selenium.is_element_present("css=div#tab-blogroll div:nth-child(2).selected") rescue false); sleep 1 }
    # Open 2nd game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(3).game-row td.up-com div.gameShortCuts a"), "'Reviews' text or <a> does not display in the second entry when reviews are sorted by editor's choice"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(3).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "Second entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "Second entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Back to Reviews Index
    @selenium.open "http://www.ign.com/index/reviews.html"
    # Sort by Editor's Choice
    @selenium.click("css=div#tab-blogroll a[href*=\"editorsChoice\"]")
    # Wait for sorted to populate
    assert !60.times{ break if (@selenium.is_element_present("css=div#tab-blogroll div:nth-child(2).selected") rescue false); sleep 1 }
    # Open 3rd game review
    begin
        assert_equal "Reviews", @selenium.get_text("css=table#table-section-index tbody tr:nth-child(4).game-row td.up-com div.gameShortCuts a"), "'Reviews' text or <a> does not display in the third entry when reviews are sorted by editor's choice"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "css=table#table-section-index tbody tr:nth-child(4).game-row td.up-com div.gameShortCuts a"
    @selenium.wait_for_page_to_load "30000"
    # Verify on review page
    assert !60.times{ break if (@selenium.is_element_present("css=meta[content*=Review]") rescue false); sleep 1 }
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_title, "First entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Review[\s\S]*$/ =~ @selenium.get_text("css=div#articleHeader h1"), "Third entry in the reviews page (sort by editor's choice) does not lead to a review page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END END END 
  end
end
