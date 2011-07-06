require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'mod1'

class BlankPageChecker < Test::Unit::TestCase

	include Mod1

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
  
  def test_for_blank_page
  
	sign_in
	
	file = File.new("wiki_guides.txt", "r")
	while (guide = file.gets)
		@selenium.open(guide.to_s)
		#CHECK FOR A THIRD EMBEDED DIV
		begin
			assert @selenium.is_element_present("css=div div div"), "Unable to verify a third embeded div is found on the following guide -- #{guide}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK 50 CHARS OF TEXT IS PRESENT
		body_text = @selenium.get_body_text
		begin
			assert body_text.length > 25, "Unable to verify the length of the body text to the following is greater than 25 -- #{guide}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK ONE IMAGE IS PRESENT
		begin
			assert @selenium.is_element_present("css=img[src*='http']"), "Unable to verify at least one image is found on the following guide -- #{guide}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK HEADER LINKS ARE PRESENT
		begin
			assert @selenium.is_element_present("css=ul#ign-globalNav"), "Unable to verify IGN global nav is found on the following guide -- #{guide}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	file.close
  end
end