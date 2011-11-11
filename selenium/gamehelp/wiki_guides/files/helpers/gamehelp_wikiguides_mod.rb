
module GameHelpWikiGuidesMod

  def sign_in(start_page)

	@selenium.open "http://my.ign.com/login?r=#{start_page}#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def open(url)
    @selenium.open(url)
    while @selenium.get_title() == "IGN Advertisement"
      @selenium.click("css=div#header-text a")
      @selenium.wait_for_page_to_load "40"
    end
  end
  
  def rand_num
	r = rand(100000)+1000
	r.to_s
  end
  
  # GENERAL PAGE FUNCTIONS
	
  def check_object_header(page)
	begin
		assert @selenium.is_element_present("css=div.contentHeaderNav div.contentHead"), "Unable to verify the object header is present ont the #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
end
	
  def check_object_header_title(page)
	if @selenium.is_element_present("css=div.contentHead h2.contentTitle a")
		text = @selenium.get_text("css=div.contentHead h2.contentTitle a")
			if text.length > 1 then bool = "true" 
				else bool = ""
			end
		begin
			assert_equal "true", bool, "Unable to verify the object's title is present in the object header on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else 
		begin
			assert @selenium.is_element_present("css=div.contentHead h2.contentTitle a"), "Unable to verify the object's title is present in the object header on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end

  def check_object_header_platform(page)
	if @selenium.is_element_present("css=div.contentHead div.contentPlatformsText")
		text = @selenium.get_text("css=div.contentHead div.contentPlatformsText")
		if text.length > 1 then bool = "true" 
		else bool = ""
		end
		begin
			assert_equal "true", bool, "Unable to verify the object's platform is present in the object header on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=div.contentHead div.contentPlatformsText"), "Unable to verify the object's platform is present in the object header on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
	
  def check_object_header_facebook_like(page)
	begin
		assert @selenium.is_element_present("css=div#LikePluginPagelet a.connect_widget_like_button"), "Unable to verify the Facebook Like button is present in the object header on the #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_object_nav(page)
	begin
		assert @selenium.is_element_present("css=ul.contentNav li:nth-child(3) > a[href*='http']"), "Unable to verify the object nav is present on the #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_guide_nav(page)
	nav_elements = {
	"Guide Nav" => "", 
	"Guide Nav Search" => " form#wikiSearchForm input.ghn-searchBox", 
	"Home Wiki Guide page link in Guide Nav" => " div.ghn-home a",
	"Video Wiki Guide page link in Guide Nav" => " div.ghn-videos a",
	"Guide Nav Add Page Link" => " div.ghn-footer a.addpage", 
	"Guide Nav Edit Page Link" => " div.ghn-footer a.editnav"
	}
	nav_elements.each do |k,v|
		begin
			assert @selenium.is_element_present("css=div.ghn#{v}"), "Unable to verify the #{k} is present on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_rr_mod_tools(page)
	mod_tool_elements = {
	"History" => "a[class='gh-bigButton gh-historyButton']", 
	"Discuss" => "a[class='gh-bigButton gh-discussButton']", 
	"Flag Page" => "a[class='gh-bigButton gh-flagButton']", 
	}
	mod_tool_elements.each do |k,v|
		begin
			assert @selenium.is_element_present("css=div.gh-rightRail #{v}"), "Unable to verify the #{k} moderation tool/button is present in the right rail of the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_med_rec_ad(page)
	begin
		assert @selenium.is_element_present("css=div.gh-rightRail div.gh-medRecAd"), "Unable to verify the Med_Rec_Ad is present in the right rail of the #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  
  
  end
  
  def check_staff_contact(page)
	begin
		assert @selenium.is_element_present("css=div.gh-rightRail div.player-icon a[href*='people.ign.com/'] img"), "Unable to verify the Staff Contact box in the right rail of the #{page} shows the staff's MyIGN avatar pic and links to his profile page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_content_title(page)
	if @selenium.is_element_present("css=div.grid_16 h1")
		text = @selenium.get_text("css=div.grid_16 h1")
		if text.length > 1 then bool = "true" 
		else bool = ""
		end
		begin
			assert_equal "true", bool, "Unable to verify a content header/title appears on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=div.grid_16 h1"), "Unable to verify a content header/title appears on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_content_body(page)
	if @selenium.is_element_present("css=div.grid_16 div.grid_12 p")
		text = @selenium.get_text("css=div.grid_16 div.grid_12 p")
		if text.length > 1 then bool = "true" 
		else bool = ""
		end
		begin
			assert_equal "true", bool, "Unable to verify any content appears in the body of the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=div.grid_16 div.grid_12 p"), "Unable to verify any content appears in the body of the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_more_wiki_guides(page)
	if @selenium.is_element_present("css=div.grid_16 h2.gh-h2")
		begin
			assert /More Wiki Guides/ =~ @selenium.get_text("css=div.grid_16 h2.gh-h2"), "Unable to verify the 'More Wiki Guides' subheader appears below the main content on the #{page}. The following text is present: #{@selenium.get_text("css=div.grid_16 h2.gh-h2")}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=div.grid_16 h2.gh-h2"),  "Unable to verify the 'More Wiki Guides' subheader appears below the main content on the #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_footer(page)
	begin
		assert @selenium.is_element_present("css=div#ignFooter-container div.ignFooter-content div.ignFooter-topRow"), "Unable to verify the global top-row-footer is present on the #{page}'"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert @selenium.is_element_present("css=div#ignFooter-container div.ignFooter-content div.ignFooter-bottomRow"), "Unable to verify the global bottom-row-footer is present on the #{page}'"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  #ADD PAGE FUNCTIONS
  
  def check_addpage_title_field(page)
	begin
		assert @selenium.is_element_present("css=form#ghEditForm input#Wiki_title"), "Unable to verify the title-entry text field is present when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_addpage_editor_ui(page)
	begin
		assert @selenium.is_element_present("css=form#ghEditForm span#cke_Wiki_markup table.cke_editor"), "Unable to verify the editor UI appears when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_addpage_save_preview_cancel_buttons(page)
	editor_buttons = {
	"Save" => "a.gh-saveButton", 
	"Preview" => "a.gh-previewButton", 
	"Cancel" => "a.gh-cancelButton", 
	}
	editor_buttons.each do |k,v|
		begin
			assert @selenium.is_element_present("css=div.grid_16 #{v}"), "Unable to verify the #{k} button appears at the bottom of the page when adding a new page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_addpage_add_dropdown_menu(page)
	begin
		assert @selenium.is_element_present("css=div.grid_16 select#Wiki_nav_placement option"), "Unable to verify the wiki nav placement drop down menu is present when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert @selenium.is_element_present("css=div.grid_16 select#Wiki_nav_position option"), "Unable to verify the wiki nav position drop down menu is present when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_addpage_save_preview_cancel_buttons_rightrail(page)
	editor_buttons_rr = {
	"Save" => "a.gh-saveButton", 
	"Preview" => "a.gh-previewButton", 
	"Cancel" => "a.gh-cancelButton", 
	}
	editor_buttons_rr.each do |k,v|
		begin
			assert @selenium.is_element_present("css=div.gh-rightRail #{v}"), "Unable to verify the #{k} button appears in the right rail of the page when adding a new page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_media_library(page)
	begin
		assert @selenium.is_element_present("css=div.gh-rightRail div#gh-mediaLibrary div.gh-mediaLibrary-list"), "Unable to verify the Media Library is present when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	#Check there is at least one image or video in media library
	begin
		assert @selenium.is_element_present("css=div#gh-mediaLibrary div.gh-mediaLibrary-list div.gh-mediaLibrary-listItem"), "Unable to verify the Media Library contains at least one image or video when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end 
	#Check Media Library tabs are present 
	media_tabs_locators = ["gh-mediaLibrary-showAll", "gh-mediaLibrary-showImages", "gh-mediaLibrary-showVideos"]
	media_tabs_locators.each do |n|
		begin
			assert @selenium.is_element_present("css=div#gh-mediaLibrary ul.gh-tabs li.#{n} a"), "Unable to verify one of the Media Library tabs is present and functional when adding a new page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end 
	end
	#Check Upload button
	begin
		assert @selenium.is_element_present("css=div.gh-rightRail div#gh-mediaLibrary a.gh-uploadButton"), "Unable to verify the Media Library's Upload button is present and functional on when adding a new page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end 
  end
  
  #EDIT NAV PAGE FUNCTIONS
  
  def check_editnav_save_button(page)
	begin
		assert @selenium.is_element_present("css=div.grid_24 form#navForm a#ghNavigationSave"), "Unable to verify the save button appears when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_editnav_cancel_button(page)
	begin
		assert @selenium.is_element_present("css=div.grid_24 form#navForm a.gh-cancelButton"), "Unable to verify the cancel button appears when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_editnav_addsections(page)
	begin
		assert @selenium.is_element_present("css=div.grid_16 div.gh-navEditor-3col ul#firstLevel"), "Unable to verify the 'Sections' column is present when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_editnav_addsection_button(page)
	begin
		assert @selenium.is_element_present("css=div.grid_16 div.gh-navEditor-3col a#firstLevelAdd"), "Unable to verify the 'Add Section' button is present in the 'Sections' column when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_editnav_addpages(page)
	begin
		assert @selenium.is_element_present("css=div.grid_16 div.gh-navEditor-3col ul#secondLevel"), "Unable to verify the 'Pages' column is present when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_editnav_addsubpages(page)
	begin
		assert @selenium.is_element_present("css=div.grid_16 div.gh-navEditor-3col ul#thirdLevel"), "Unable to verify the 'Sub-pages' column is present when in the nav editor"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  
end