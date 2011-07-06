require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/helpers/gamehelp_wikiguides_mod'
require 'files/helpers/global_header_mod'

class GameHelpWikiGuidesSmoke < Test::Unit::TestCase

  include GlobalHeaderMod
  include GameHelpWikiGuidesMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_gamehelp_wikiguides_smoke
  
	main_page = "/wikis/la-noire"
 
	sign_in("http://www.ign.com/")
	@selenium.open(main_page)
	global_header("index pages")
	check_object_header("index pages")
	check_object_header_title("index pages")
	check_object_header_platform("index pages")
	check_object_header_facebook_like("index pages")
	check_object_nav("index pages")
	check_guide_nav("index pages")
	check_rr_mod_tools("index pages")
	check_staff_contact("index pages")
	check_med_rec_ad("index pages") 
	check_content_title("index pages")
	check_content_body("index pages")
	check_more_wiki_guides("index pages")
	check_footer("index pages")
	
	#Click Add Page
	@selenium.click("css=div.ghn div.ghn-footer a.addpage")
	@selenium.wait_for_page_to_load("40")
	global_header("add a wiki entry pages")
	check_object_header("add a wiki entry pages")
	check_object_header_title("add a wiki entry pages")
	check_object_header_platform("add a wiki entry pages")
	check_object_header_facebook_like("add a wiki pages")
	check_object_nav("add a wiki entry pages")
	check_guide_nav("add a wiki entry pages")
	check_footer("add a wiki entry pages")
	
	#Unique Add Page Functions
	check_addpage_title_field("add a wiki entry pages")
	check_addpage_editor_ui("add a wiki entry pages")
	check_addpage_add_dropdown_menu("add a wiki entry pages")
	check_addpage_save_preview_cancel_buttons("add a wiki entry pages")
	check_addpage_save_preview_cancel_buttons_rightrail("add a wiki entry pages")
	check_media_library("add a wiki entry pages")
	
	#Click Edit Nav
	@selenium.open(main_page)
	@selenium.click("css=div.ghn div.ghn-footer a.editnav")
	@selenium.wait_for_page_to_load("40")
	global_header("edit nav pages")
	check_object_header("edit nav pages")
	check_object_header_title("edit nav pages")
	check_object_header_platform("edit nav pages")
	check_object_header_facebook_like("edit nav pages")
	check_object_nav("edit nav pages")
	check_content_title("edit nav pages")
	check_footer("edit nav pages")
	
	#Unique Edit Nav Page Functions
	check_editnav_save_button("edit nav pages")
	check_editnav_cancel_button("edit nav pages")
	check_editnav_addsections("edit nav pages")
	check_editnav_addsection_button("edit nav pages")
	check_editnav_addpages("edit nav pages")
	check_editnav_addsubpages("edit nav pages")

  end
end