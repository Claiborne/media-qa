require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/gamehelp_cheats_module"

class GameHelpCheatsObjPage < Test::Unit::TestCase

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
  
  def test_gamehelp_cheats_obj_page
	signin
	
	#OPEN CHEAT PAGE USING URL STRUCTURE
	open_cheat_page
	
	#NAV -- VERIFY THAT IF A CHEAT CATEGORY HAS AT LEAST 1 PUBLISHED ENTRY, THEN THAT CATEGORY CAN BE SORTED IN THE CHEATS NAV
	subcheat = Array.new	
		#All	
	begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='showCheatCategory('all')']"), "The 'All' link in the cheats nav may not be present"
    rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
		#Cheats
	if @selenium.is_element_present("css=div#category_cheat h2")
		subcheat << "category_cheat"
		begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='showCheatCategory('cheat')']"), "The 'Cheats' link in the cheats nav may not be present"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end
		#Unlockables
	if @selenium.is_element_present("css=div#category_unlockable h2")
		subcheat << "category_unlockable"
		begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='showCheatCategory('unlockable')']"), "The 'Unlockables' link in the cheats nav may not be present"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end
		#Hints
	if @selenium.is_element_present("css=div#category_hint h2")
		subcheat << "category_hint"
		begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='showCheatCategory('hint')']"), "The 'Hints' link in the cheats nav may not be present"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end
		#Easter Eggs
	if @selenium.is_element_present("css=div#category_easter-egg h2")
		subcheat << "category_easter-egg"
		begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='showCheatCategory('easter-egg')']"), "The 'Easter Egg' link in the cheats nav may not be present"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end
		#Achievements
	if @selenium.is_element_present("css=div#category_achievement h2")
		subcheat << "category_achievement"
		begin
		assert @selenium.is_element_present("css=div[class='maintext14 links'] a[onclick*='achievement']"), "The 'Achievements' link in the cheats nav may not be present"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end
	
	#VERIFY NUM OF ENTRIES LISTED IN EACH SUBHEADING 
	#MATCH ACTUAL NUM ENTIRES 
	#AND MATCH NUM AUTHOR PROFILE LINKS
	subcheat.each do |i|
		#How many entires does the subheader see?
		text = @selenium.get_text("css=div#"+i+" h2")
		text = text.gsub(/[^0-9]/, "")
		
		#Verify there are at least that many h3 entires in under the subheader
		h3_count = @selenium.get_xpath_count("//div[@id='"+i+"']//h3")
		begin
		assert text.to_i == h3_count.to_i, "The number of entries listed in the "+i+" subheding does not match the actual num of entries under that subheading"
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
		
		#Verify for each entry, there is a link that contains 'http://people.ign.com/'
		begin
		assert h3_count.to_i == @selenium.get_xpath_count("//div[@id='"+i+"']//a[contains(@href,'http://people.ign.com/')]").to_i, "The number of 'Submitted by' profile link do not match the number of cheat headers under the subcheat "+i+""
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
	end

	#VERIFY FIRST 'SUBMITTED BY' AUTHOR LINK ACTUALLY LEADS TO A PROFILE PAGE
	@selenium.click("css=div.cheatBody a[href*='people.ign']")
	@selenium.wait_for_page_to_load "40"
	begin
        assert /^[\s\S]*Profile[\s\S]*$/ =~ @selenium.get_title, "The first 'Submitted by' author link might not lead to an actual profile page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end