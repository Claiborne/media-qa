require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/gamehelp_cheats_module"

class GameHelpCheatsSubmissions < Test::Unit::TestCase
	
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
  
  def test_gamehelp_cheats_submissions
	signin
	
	# OPEN POKEMON CHEAT PAGE
	open_cheat_page
	
	# SUBMIT CHEATS
	
	# Cheat
	cheat_open_type
	cheat_type "cheat"
	submit
	verify_submission
	another_cheat
	
	# Unlockable
	cheat_open_type
	cheat_type "unlockable"
	submit
	verify_submission
	another_cheat
	
	# Hints
	cheat_open_type
	cheat_type "hint"
	submit
	verify_submission
	another_cheat
	
	# Easter Egg
	cheat_open_type
	cheat_type "easter-egg"
	submit
	verify_submission
	another_cheat
	
	# Achievement
	cheat_open_type
	cheat_type "achievement"
	submit
	verify_submission
	
	# Refresh page and try to submit a cheat w/ no category
	@selenium.refresh
    @selenium.wait_for_page_to_load "40"
	cheat_open_type
	submit
	sleep 2
	begin
        assert !@selenium.is_visible("css=div[class='resultsBox grid_20']"), "User seems to be able to successfully submit a cheat without specifying a cheat category"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end