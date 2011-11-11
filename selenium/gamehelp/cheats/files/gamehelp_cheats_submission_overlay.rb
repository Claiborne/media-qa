require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/gamehelp_cheats_module"
#NOTE: This test does not sumbit a cheat, only tests the submission overlay

class GameHelpCheatsSubmissionOverlay < Test::Unit::TestCase
	
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
  
  def test_gamehelp_cheats_submission_overlay
	signin
	
	# OPEN POKEMON BLACK CHEAT PAGE
	open_cheat_page
	
	# OPEN OBJECT PAGE TO GRAB  TITLE AND PLATFORM FOR LATER COMPARE TO CHEAT SUBMISSION OVERLAY
	game_title = @selenium.get_text "css=h2.contentTitle"
	game_platform = @selenium.get_text "css=title"
	
	# CLICK SUBMIT A CHEAT
	@selenium.click "css=a#control"
    assert !6.times{ break if (@selenium.is_visible("css=div#light") rescue false); sleep 1 }, "Unable to verify the cheat-submission lightbox become visible after clicking 'Submit a cheat for this game'"
	
	# CLICK TITLE FIELD AND VERIFY PLACEHOLDER TEXT REMOVED
	@selenium.click "css=input#title"
	begin
        assert_equal "", @selenium.get_text("css=input#title"), "On the cheat submission overlay, unable to verifty that when the title field is clicked on, the placeholder text was removed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# CLICK BODY FIELD AND VERIFY PLACEHOLDER TEXT REMOVED
    @selenium.click "css=body#tinymce"
	begin
        assert_equal "", @selenium.get_text("css=body#tinymce"), "On the cheat submission overlay, unable to verifty that when the body field is clicked on, the placeholder text was removed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# USER BADGE IS LINKED TO USER PROFILE PAGE
	begin
        assert @selenium.is_element_present("css=div.player-icon a[href*='http://people.ign.com/']"), "On the cheat submission overlay, unable to verify user badge/icon links to the user profile page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# GAME TITLE AND PLATFORM APPEAR CORRECTLY ON OVERLAY
	begin
        assert_equal game_title, @selenium.get_text("css=form[name=cheat] div.subtext12 span"), "Unable to verify correct game title appears on cheat submission overlay"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	game_plat_appears = @selenium.get_text("css=form[name=cheat] div.subtext12").sub("for ","").sub(@selenium.get_text("css=form[name=cheat] div.subtext12 span"),"").strip
	
	begin
        assert /.*#{game_plat_appears}.*/ =~ @selenium.get_text("css=form[name=cheat] div.subtext12"), "Unable to verify correct game platform appears on cheat submission overlay"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end	
  end
end