require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/helpers/gamehelp_wikiguides_mod'

class GameHelpWikiGuidesFunctional < Test::Unit::TestCase

  include GameHelpWikiGuidesMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://wiki.stg.www.ign.com/guides/qa",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_gamehelp_wikiguides_functional
	
	
	sign_in("http://wiki.stg.www.ign.com/guides/qa/")
	nav_page_title = @selenium.get_text("css=div.ghn div.ghn-subNav:nth-child(9)")
	
	#ADD PAGE THROUGH 'ADD PAGE' BUTTON AND ADD TO NAV
	@selenium.click "css=div.ghn-footer a.addpage"
	@selenium.wait_for_page_to_load "40"
	sleep 3
	
	title_text = "TitleTEST"+rand_num
	body_text = "body"+rand_num
	
	@selenium.type "Wiki_title", title_text
	@selenium.type "css=body.cke_show_borders", body_text
	
	@selenium.select "Wiki_nav_placement", "label=As a child of"
    @selenium.select "Wiki_nav_position", "label=Test Page 1"
	sleep 3
	
	@selenium.click "css=a.gh-saveButton"
	@selenium.wait_for_page_to_load "40"
	
	#CHECK PAGE GENERATED AND WAS ADDED TO NAV
	@selenium.open "http://wiki.stg.www.ign.com/guides/qa"
	
	#Check page added to nav
	begin 
		assert @selenium.get_text("css=div.ghn").match(/#{title_text}/), "Unable to verify a new page will be added to the wiki nav"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
	#Check page loads, body and title string
	@selenium.open "http://wiki.stg.www.ign.com/guides/qa/#{title_text}"
	begin 
		assert @selenium.get_text("css=div.grid_12 h1").match(/#{title_text}/), "Unable to verify the new page contains the title that was specified in the editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	begin 
		assert @selenium.get_text("css=div.grid_12 p").match(/#{body_text}/), "Unable to verify the new page contains the body that was specified in the editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
	#EDIT PAGE
	@selenium.open "http://wiki.stg.www.ign.com/guides/qa/Test_Page_1"
	@selenium.click "css=a[href='/guides/qa/edit/Test_Page_1']"
	@selenium.wait_for_page_to_load "40"
	sleep 3
	
	edit_body_text = "body"+rand_num
	
	@selenium.type "css=body.cke_show_borders", edit_body_text
	sleep 2
	@selenium.click "css=a.gh-saveButton"
	@selenium.wait_for_page_to_load "40"
	
	#Check body string has changed
	begin 
		assert @selenium.get_text("css=div.grid_12 p").match(/#{edit_body_text}/), "Unable to verify editing a page's body works"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
	#SEARCH
	@selenium.open "http://wiki.stg.www.ign.com/guides/qa"
	@selenium.type "term", "test"
    @selenium.click "css=div.ghn-search a"
    @selenium.wait_for_page_to_load "40"
	
	#Check "Search Results" present
	begin 
		assert @selenium.get_text("css=div.grid_16 h1").match(/Search Results/), "Unable to verify clicking the search button takes the user to the results page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
	#Check at least one result shows up
	begin 
		assert @selenium.is_element_present("css=div.gh-searchResultItem"), "Unable to verify search returns results"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
	#Check result has title and body text
	search_title = @selenium.get_text "css=div.gh-searchResultItem h3"
	search_body = @selenium.get_text "css=div.gh-searchResultItem p"
	if search_title.length > 1 then bool = "true"
		else bool = ""
	end
	if search_body.length > 1 then bool = "true"
		else bool = ""
	end
	begin
		assert_equal "true", bool, "Unable to verify the object's title is present in the object header on the index pages"
	rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
	end
	begin
		assert_equal "true", bool, "Unable to verify the object's title is present in the object header on the index pages"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#CHECK EDIT NAV: ABLE TO DRILL DOWN TO VIEW SUB-PAGES
	@selenium.open "http://wiki.stg.www.ign.com/guides/qa/edit/Ign:Navigation"
	
	@selenium.click "css=ul#firstLevel li"
	sleep 2
    @selenium.click "css=ul#secondLevel li"
	sleep 2
    begin
        assert @selenium.is_element_present("css=ul#secondLevel li"), "On the Edit Nav page, unable to verify clicking on pages lets you view the subpages in the next column"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul#thirdLevel li"), "On the Edit Nav page, unable to verify clicking on pages lets you view the subpages in the next column"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	#CHECK DRAG AND DROP WORKS
	@selenium.click "css=li#firstLevel1"
	sleep 2
	
	edit_page_title = @selenium.get_text "css=li#secondLevel2"
	
	@selenium.drag_and_drop_to_object "css=li#secondLevel2 a", "css=li#secondLevel0"
	sleep 3
	
	begin
        assert_not_equal @selenium.get_text("css=li#secondLevel2"), edit_page_title, "Unable to verify the drag and drop function on the Edit Nav page works"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# ADD A PAGE THROUGH EDIT NAV
	@selenium.click "css=li#firstLevel1"
	sleep 2
    @selenium.click "css=li#secondLevel0"
    assert !60.times{ break if (@selenium.is_visible("css=a#thirdLevelAdd") rescue false); sleep 1 }
    @selenium.click "thirdLevelAdd"
	subpage_title = "Sub"+rand_num
    @selenium.answer_on_next_prompt(subpage_title)
    assert_equal "Please enter the name of the new page", @selenium.get_prompt
	@selenium.click "thirdLevelAdd"
	begin
        assert @selenium.get_text("css=ul#thirdLevel").match(/#{subpage_title}/), "Unable to verify adding a page throught the Edit Nav page works"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	@selenium.click("css=a#ghNavigationSave")
	@selenium.wait_for_page_to_load("40")
	
	#CHECK NEW PAGE SAVES
	@selenium.open("http://wiki.stg.www.ign.com/guides/qa")
	begin
        assert @selenium.get_text("css=div.ghn").match(/#{subpage_title}/), "Unable to verify adding a page throught the Edit Nav page saves and appears in the Guide navigation after clicking save"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

	#CHECK DRAG AND DROP SAVES
	begin
        assert_not_equal nav_page_title,@selenium.get_text("css=div.ghn div.ghn-subNav:nth-child(9)"), "Unable to verify dragging and droping a page in the Nav Editor saves to the Guide nav"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

	#DELETE A PAGE FROM THE EDIT NAV PAGE
	@selenium.open("http://wiki.stg.www.ign.com/guides/qa/edit/Ign:Navigation")
	@selenium.click("css= li#firstLevel0")
	deleted_page = @selenium.get_text("css=li#secondLevel3")
	sleep 3
	@selenium.click("css=li#secondLevel3 a.gh-navEditor-delete")
	assert /^Are you sure you want to delete this[\s\S]$/ =~ @selenium.get_confirmation
	sleep 1
	@selenium.click("css=a#ghNavigationSave")
	@selenium.wait_for_page_to_load("40")
	#CHECK PAGE DELETED FROM THE NAV
	@selenium.open("http://wiki.stg.www.ign.com/guides/qa")
	begin
        assert !@selenium.get_text("css=div.ghn").match(/#{deleted_page}/), "Unable to verify deleted page deleted from nav"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	#LOGOUT
	open("http://my.ign.com/logout?r=http://wiki.stg.www.ign.com/guides/qa/")
	
	#CHECK 'ADD PAGE' AND 'EDIT NAV' LINKS NOT DISPLAY
	begin
        assert !@selenium.is_element_present("css=a[href*='/guides/qa/add?navsection']"), "Unable to verify that when logged out, a link to the Add Page page is not present"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert !@selenium.is_element_present("css=a[href*='/guides/qa/edit/Ign:Navigation']"), "Unable to verify that when logged out, a link to the Edit Nav page is not present"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	open("http://wiki.stg.www.ign.com/guides/qa/Test_Page_1")
	@selenium.click("css=h1 a.gh-miniButton")
	sleep 3
	#CHECK CLICKING 'EDIT PAGE' BUTTON NOT ALLOW EDIT
	begin
        assert_equal "http://wiki.stg.www.ign.com/guides/qa/Test_Page_1", @selenium.get_location, "Unable to verify the 'Edit Page' button does not allow editing for a logged out user"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end