require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class MainPage360Tab < Test::Unit::TestCase

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
  
  def test_main_page360_tab
    # MAIN PAGE -> 360 BLOGROLL TAB. ALL MATCH 360, NO DUPLICATES, PREV TEXT PRESENT
    # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
    # END SIGN IN
    # Open IGN Main
    @selenium.open "/"
    # Sort blogroll by Xbox 360
    @selenium.click "css=a[href='http://xbox360.ign.com/']"
    # Wait for sort to populate
    assert !15.times{ break if (@selenium.is_element_present("css=ul#left-col-consoles a[href=http://xbox360.ign.com/][class*=selected]") rescue false); sleep 1 }
    # Verify all "Xbox 360" (skips headlines 3 and 9 for Daily Fix and Spotlight)
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(1).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 1st article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 2nd article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(4).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 3rd article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(5).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 4th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(6).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 5th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(7).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 6th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(8).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 7th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(10).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 8th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(11).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 9th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(12).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 10th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(13).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 11th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Xbox360[\s\S]*$/ =~ @selenium.get_text("css=div#all-news div:nth-child(14).headlines div.txt-para div.content-headlines span"), "Main page, blogroll filter 360: 12th article not showing Xbox360"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

    # Verify no duplicate titles
    text = [
	@selenium.get_text("css=div#all-news div:nth-child(1).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(2).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(4).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(5).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(6).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(7).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(8).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(10).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(11).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(12).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(13).headlines div.txt-para h3.hdr"),
	@selenium.get_text("css=div#all-news div:nth-child(14).headlines div.txt-para h3.hdr")
	]
	for i in 0..11 do
		for j in 0..11 do
				if i != j then 
					begin
						assert text[i] != text[j] , "There is a duplicate article on the main-page under 360 blogroll tab"
					rescue Test::Unit::AssertionFailedError
						@verification_errors << $!
					end
		end
	end
	# END verify no duplicate titles
	# Verify blogroll preview text present each entry
	for i in 1..2 do
		title = @selenium.get_text("css=div#all-news div:nth-child(" + i.to_s + ").headlines div.txt-para div.content-headlines")
		#puts title
			if title.length > 47 then bool = "true" 
			else bool = ""
			end
		begin
			assert_equal "true", bool, "Preview text may not be present in one of the main-page 360 blogroll articles"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	for i in 4..8 do
		title = @selenium.get_text("css=div#all-news div:nth-child(" + i.to_s + ").headlines div.txt-para div.content-headlines")
		#puts title
			if title.length > 47 then bool = "true" 
			else bool = ""
			end
		begin
			assert_equal "true", bool, "Preview text may not be present in one of the main-page 360 blogroll articles"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	for i in 10..14 do
		title = @selenium.get_text("css=div#all-news div:nth-child(" + i.to_s + ").headlines div.txt-para div.content-headlines")
		#puts title
			if title.length > 47 then bool = "true" 
			else bool = ""
			end
		begin
			assert_equal "true", bool, "Preview text may not be present in one of the main-page 360 blogroll articles"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	# End verify blogroll preview text present each entry
    # END END END
end
end
end
