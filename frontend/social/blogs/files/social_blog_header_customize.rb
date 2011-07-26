require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class SocialBlogHeader< Test::Unit::TestCase

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
  
  def test_social_blog_header_upload
	#SIGN IN
	@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
	@selenium.wait_for_page_to_load "40"
	@selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
	
	# GO TO BLOGS PAGE
	@selenium.open "http://www.ign.com/blogs/clay.ign/"
	@selenium.wait_for_page_to_load "40"
	
	# CLICK 'UPLOAD A NEW HEADER'
	@selenium.click "link=Upload a New Header"
	@selenium.wait_for_page_to_load "40"
	
	# IF MISDIRECTED TO LOGNIN, REDO STEPS
	while @selenium.get_title == "Login - IGN"
		@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
		@selenium.wait_for_page_to_load "40"
		@selenium.click "emailField"
		@selenium.type "emailField", "smoketest@testign.com"
		@selenium.type "passwordField", "testpassword"
		@selenium.click "signinButton"
		@selenium.wait_for_page_to_load "40"
		
		# GO TO BLOGS PAGE
		@selenium.open "http://www.ign.com/blogs/clay.ign/"
		@selenium.wait_for_page_to_load "40"
	
		# CLICK 'UPLOAD A NEW HEADER'
		@selenium.click "link=Upload a New Header"
		@selenium.wait_for_page_to_load "40"
	end
	
	# UPLOAD A HEADER AND SUBMIT
	@selenium.type "header_image_url", "http://oyster.ignimgs.com/wordpress/write.ign.com/57231/2011/04/snake_header.jpg"
    @selenium.click "submit"
    @selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("User updated."), "After uploading a blog header image and clicking 'Udate Profile', the 'User updated' notification did not appear"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    sleep 3
    @selenium.click "css=span#site-title"
    @selenium.wait_for_page_to_load "40"
    begin
        assert @selenium.is_element_present("css=div[style*='http://oyster.ignimgs.com/wordpress/write.ign.com/57231/2011/04/snake_header.jpg']"), "Unable to verify upload a new blog header image"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# CLICK 'UPLOAD A NEW HEADER'
	@selenium.click "link=Upload a New Header"
	@selenium.wait_for_page_to_load "40"
	
	# UPLOAD AN INCORRECTLY-SIZED IMAGE AND SUBMIT
	@selenium.type "header_image_url", "http://oyster.ignimgs.com/wordpress/write.ign.com/57231/2011/04/header_videogames.jpg"
    @selenium.click "submit"
    @selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("ERROR: Your header image must be exactly 972 pixels wide by 270 pixels high."), "After uploading an incorrectly-sized blog header image, was unable to verify the standard error message 'Your header image must be exactly 972 pixels wide by 270 pixels high' appeared"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    sleep 1
    @selenium.click "css=span#site-title"
    @selenium.wait_for_page_to_load "40"
    begin
        assert !@selenium.is_element_present("css=div[style*='http://oyster.ignimgs.com/wordpress/write.ign.com/57231/2011/04/header_videogames.jpg']"), "Unable to verify upload a new blog header"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# CLEAN UP:
	
	# CLICK 'UPLOAD A NEW HEADER'
	@selenium.click "link=Upload a New Header"
	@selenium.wait_for_page_to_load "40"
	
	# ERASE HEADER
    @selenium.type "header_image_url", ""
	@selenium.click "submit"
	@selenium.wait_for_page_to_load "40"
  end
end