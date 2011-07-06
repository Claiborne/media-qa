require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
$:.unshift '.'
require "files/helpers/gamehelp_cheats_module"

class GameHelpCheatsSmoke < Test::Unit::TestCase
	
  include SocialCheatsObjMod

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
  
  def test_gamehelp_cheats_smoke
	signin

	# OPEN POKEMON AND CLICK CHEATS
	@selenium.open "http://ds.ign.com/objects/059/059687.html"
	@selenium.wait_for_page_to_load "40"
	@selenium.click "css=div#nav-content a[href*='cheats']"
	@selenium.wait_for_page_to_load "40"
	
	# URL STRUCTURE CONTAINS 'www.ign.com/cheats/games'
	begin
        assert /^[\s\S]*www\.ign\.com\/cheats\/games\/[\s\S]*$/ =~ @selenium.get_location, "Pokemon Black Cheats page: URL structure does not contain 'www.ign.com/cheats/games/' -- possible on wrong page or URL structure for cheats has changed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# CONTENT TITLE = 'Pokemon Black Version Cheats & Codes'
	begin
        assert_equal "Pokemon Black Version Cheats & Codes", @selenium.get_text("css=h1"), "Pokemon Black Cheats page: The content title (above content nav) indicates not on Pokemon Black Cheats page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY NAV = 'All | Cheats | Unlockables | Hints | Easter Eggs | Achievements'
	begin
        assert_equal "All | Cheats | Unlockables | Hints | Easter Eggs | Achievements", @selenium.get_text("css=div[class='maintext14 links']"), "The content nav does not contain 'All | Cheats | Unlockables | Hints | Easter Eggs | Achievements'"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY CONTENT BODY SUBHEADING. 'CHEATS' 'UNLOCKABLES' 'HINTS' AND 'EASTER EGGS'
	begin
        assert /^[\s\S]*Cheats[\s\S]*$/ =~ @selenium.get_text("css=div#category_cheat h2"), "Cheats subheading not found within Pokemon Black cheats page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Unlockables[\s\S]*$/ =~ @selenium.get_text("css=div#category_unlockable h2"), "Unlockables subheading not found within Pokemon Black cheats page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Hints[\s\S]*$/ =~ @selenium.get_text("css=div#category_hint h2"), "Hints subheading not found within Pokemon Black cheats page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Easter Eggs[\s\S]*$/ =~ @selenium.get_text("css=div#category_easter-egg h2"), "Easter Eggs subheading not found within Pokemon Black cheats page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY FIRST CHEATS CONTENT ENTRY, TITLE AND BODY STRING > 0
	title = @selenium.get_text("css=div[class='grid_12 omega'] h3")
	body = @selenium.get_text("css=div[class='grid_12 omega'] span p")
	bool = ""
	if title.length > 0 then bool = "true" 
		else bool = ""
	end
    begin
        assert_equal "true", bool, "No title exists in the first cheat entry of the Pokemon Black page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	if body.length > 0 then bool = "true" 
		else bool = ""
	end
    begin
        assert_equal "true", bool, "No body exists in the first cheat entry of the Pokemon Black page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# VERIFY THERE IS A USER LINK ATTACHED TO THE FIRST CHEAT ENTRY
	begin
        assert @selenium.is_element_present("css=div[class=\"grid_4 alpha clearblock\"] a[href*='http://people.ign.com/']"), "There seems to be no 'Submitted by' user link attached to the first cheat entry"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# SUBMIT A CHEAT
	cheat_open_type
    cheat_type "cheat"
	submit
	verify_submission
  end
end