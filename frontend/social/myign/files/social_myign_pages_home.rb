require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/social_myign_pages_profile_mod'
require 'files/social_myign_pages_prime_mod'
require 'files/social_myign_pages_settings_mod'
require 'files/social_myign_pages_faq_mod'
require 'files/helpers/social_myign_mod'
require 'files/helpers/global_header_mod'

class SocialMyIGNPagesHome < Test::Unit::TestCase

  include SocialMyIGNMod
  include GlobalHeaderMod
  
  include SocialMyIGNPagesProfileMod
  include SocialMyIGNPagesPrimeMod
  include SocialMyIGNPagesSettingsMod
  include SocialMyIGNPagesFAQMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*firefox",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_myign_pages_homehttp
  
    #Define vars
    social_nav = {"5" => "Newsfeed", "7" => "My Profile", "9" => "Prime", "11" => "Settings", "13" => "FAQ"}
    social_nav_selector = ["css=ul.socialMyBar li > a","css=ul.socialMyBar li:nth-child(5) > a","css=ul.socialMyBar li:nth-child(7) > a","css=ul.socialMyBar li:nth-child(9) > a","css=ul.socialMyBar li:nth-child(11) > a","css=ul.socialMyBar li:nth-child(13) > a"]
    blogroll_nav_text = ["Show All", "Blog", "Games", "People"]
    blogroll_nav = {"showall"=>"Show All", "showblog"=>"Blog", "showgames"=>"Games", "showpeople"=>"People"}
    blogroll_nav_selector = ["css=div#dataTypes li.showall", "css=div#dataTypes li.showblog", "css=div#dataTypes li.showgames", "css=div#dataTypes li.showpeople"]
	
    #Sign in
    sign_in("smoke")
	
    #Open IGN.com
    @selenium.open "/"

    #Click "MyIGN" link in global nav
    @selenium.click("css=li#navItem-myign a.nav-lnk")
    @selenium.wait_for_page_to_load "40"
	
    #Check global header
    global_header(@selenium.get_location)
	
    #Check title and url
    verify_title("My Newsfeed","when clicknig MyIGN in the global nav")
    verify_url("http://my.ign.com/home","clicking the Newsfeed link in the MyIGN nav")
	
    #Check MyIGN nav: link text
    social_nav.each do |k,v|
      begin
        assert_equal v, @selenium.get_text("css=ul.socialMyBar li:nth-child(#{k}) > a"), "Unable to verify the '#{v}' link appears in the MyIGN nav on the MyIGN homepage"
      rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
      end
    end
	
    #Input text field is visible
    begin
      assert @selenium.is_element_present("css=div#updateStatusContainer input#statusField[type='text']"), "Unable to verify the status-update text field appears on the MyIGN homepage"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end

    #Check blogroll nav contain links Show All, Blog, Games, People
    blogroll_nav.each do |k,v|
      begin
        assert_equal v, @selenium.get_text("css=div#dataTypes li.#{k}"), "Unable to verify the blogroll nav displays the link '#{v}' on the MyIGN homepage"
      rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
      end
    end
	
    #Check profile box: whole box is visible, profiles views portion is visible, level bar is visible 
    begin
      assert @selenium.is_element_present("css=div.whatismyign"), "Unable to verify the profile-stats box appears in on the top of the right rail on the MyIGN homepage"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    begin
      assert @selenium.is_element_present("css=div#placeholder canvas"), "Unable to verify the 'Profile Views' graph displays in the profile-stats box of the right rail"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    begin
      assert @selenium.is_element_present("css=div#placeholder canvas:nth-child(2)"), "Unable to verify the 'Profile Views' graph displays in the profile-stats box of the right rail"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    begin
      assert @selenium.is_element_present("css=div.whatismyign div.progressIndicator"), "Unable to verify the level/experience bar displays in the profile-stats box of the right rail"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
    #Check 'Games Followed': One link with image
    begin
      assert @selenium.is_element_present("css=div#gamesIFollow div.platformThumbs a[href*='http'] img[src*='http']"), "Unable to verify the 'Games Followed' module in the right-rail of MyIGN homepage displays correctly -- unable to verify at least one thumb image and link of a followed game is present)"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
    #Check 'People Followed': One link with image
    begin
      assert @selenium.is_element_present("css=div#peopleIFollow ul.friendFacePile a[href*='http'] img[src*='http']"), "Unable to verify the 'People Followed' module in the right-rail of MyIGN homepage displays correctly -- unable to verify at least one thumb image and link of a followed person is present)"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
    #Iterate through blogroll nav, checking text and images are present for the first entry
    x = 0
    blogroll_nav_selector.each do |i|
      #Click through the nav
      @selenium.click(i)
      sleep 3
		
      #Check text in first entry: string > 27
	  if @selenium.is_element_present("css=ul#activityList li.activity span.activityContent")
		text = @selenium.get_text("css=ul#activityList li.activity span.activityContent")
		if text.length > 27 then bool = "true" 
			else bool = ""
		end
		begin
			assert_equal "true", bool, "Unable to verify any text content appears in the in the '#{blogroll_nav_text[x]}' blogroll of the MyIGN homepage"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	  else 
		begin
			assert @selenium.is_element_present("css=ul#activityList li.activity span.activityContent"), "Unable to verify any text content appears in the in the '#{blogroll_nav_text[x]}' blogroll of the MyIGN homepage"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		
		#Check image in first entry: img src *= http
		begin
			assert @selenium.is_element_present("css=ul#activityList li.activity a img[src*='http']"), "Unable to verify any images appears in the in the '#{blogroll_nav_text[x]}' blogroll of the MyIGN homepage"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		x+=1
	  end
	end
	
    #
    #ITERATE THROUGH MyIGN NAV, CHECKING EACH PAGE
    #
	
    #MYIGN LOGO
	
      #Click MyIGN logo in MyIGN nav
      @selenium.click(social_nav_selector[0])
      @selenium.wait_for_page_to_load "40"
	
      verify_title("My Newsfeed","clicking the MyIGN logo in the MyIGN nav")
      verify_url("http://my.ign.com/home","clicking the MyIGN logo in the MyIGN nav")
	
    #NEWSFEED
	
      #Click Newsfeed link in MyIGN nav
      @selenium.click(social_nav_selector[1])
      @selenium.wait_for_page_to_load "40"

      verify_title("My Newsfeed","clicking the Newsfeed link in the MyIGN nav")
      verify_url("http://my.ign.com/home","clicking the Newsfeed link in the MyIGN nav")
	  
    #MY PROFILE
	
      #Click My Profile link in MyIGN nav
      @selenium.click(social_nav_selector[2])
      @selenium.wait_for_page_to_load "40"
	
      verify_title("Profile","clicking the Profile link in the MyIGN nav")
      verify_url("http://people.ign.com/","clicking the Profile link in the MyIGN nav")
		
      check_myprofile_page
	
    #PRIME
	
      #Click Prime link in MyIGN nav
      @selenium.click(social_nav_selector[3])
      @selenium.wait_for_page_to_load "40"
		
      verify_title("Prime","clicking the Prime link in the MyIGN nav")
      verify_url("http://my.ign.com/prime/hub","clicking the Prime link in the MyIGN nav")
		
      check_prime_page
	
    #SETTINGS
	
      #Click Settings link in MyIGN nav
      @selenium.click(social_nav_selector[4])
      @selenium.wait_for_page_to_load "40"
		
      verify_title("Settings","clicking the Settings link in the MyIGN nav")
      verify_url("/settings","clicking the Settings link in the MyIGN nav")
		
      check_settings_page
	
    #FAQ
	
      #Click FAQ link in MyIGN nav
      @selenium.click(social_nav_selector[5])
      @selenium.wait_for_page_to_load "40"
	
      verify_title("FAQ","clicking the FAQ link in the MyIGN nav")
      verify_url("http://my.ign.com/help","clicking the FAQ link in the MyIGN nav")
		
      check_faq_page
		
    #
    #END 
    #
	
    #Signout
    open("http://my.ign.com/logout?r=http://my.ign.com/")
	
    #Click "MyIGN" link in global nav
    #@selenium.click("css=li#navItem-myign a.nav-lnk")
    #wait_for_page_to_load "40"
  
    #Check logged-out landing page
    verify_title("Get Started with My IGN","clicking the MyIGN link in the global nav while signed out")
    verify_url("http://my.ign.com/get-started","clicking the MyIGN link in the global nav while signed out")
  end
end