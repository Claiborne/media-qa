require "rubygems"
gem "selenium-client"
require "selenium/client"
require "net/http"
require "json"
require "test/unit"
require "helpers/social_registration_module"

class SocialRegistration < Test::Unit::TestCase

  include SocialRegistrationModule
  
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
  
  def test_social_registration
  
    # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
	
	# OPEN MAIN
	@selenium.open "/"
	@selenium.wait_for_page_to_load "40"
	
	# CLICK SIGN UP / REGISTER
	@selenium.click "css=a#lnk-reg_alpha"
	@selenium.wait_for_page_to_load "40"
	
	# VERIFY FACEBOOK LINK PRESENT
	begin
        assert @selenium.is_element_present("link=Login with Facebook")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# SAVE TITLE FOR LATER USE 
	title = @selenium.get_title
	
	# VERIFY 'USERNAME' 'EMAIL' AND 'PASSWORD' ARE REQUIRED
	
	# Type "" in each textfield
	@selenium.type "css=input#usernameField", ""
	@selenium.type "css=input#emailField", ""
	@selenium.type "css=input#passwordField", ""
	# Click Sign Up
	@selenium.click "css=button#signupButton"
	sleep 1
	# Assert still on reg page / reg failed
	begin
        assert_equal title, @selenium.get_title, "Unable to verify social registration prevented a user from creating an account with no username, e-mail, and password paramaters"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	# Assert all fields are required
	begin
        assert @selenium.is_text_present("Username is required."), "Unable to verify 'Username is required' warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_text_present("Email address is required."), "Unable to verify 'Email address is required' warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_text_present("Password is required."), "Unable to verify 'Password is required' warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY E-MAIL VALIDATION WORKS
	@selenium.type "css=input#usernameField", "a"+(rand(10000000)+100).to_s
	@selenium.type "css=input#emailField", "hello@.com"
	@selenium.type "css=input#passwordField", (rand(10000000)+10000).to_s
	@selenium.click "css=button#signupButton"
	sleep 1
	begin
        assert_equal title, @selenium.get_title, "Unable to verify social registration prevented a user from creating an account with an invalid e-mail"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_text_present("Email address is invalid."), "Unable to verify 'Email address is invalid.' warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY "_" IS AN INVALID CHAR IN USERNAME
	@selenium.type "css=input#usernameField", "a"+(rand(10000000)+100).to_s+"_"
	@selenium.type "css=input#emailField", "hello@.com"
	@selenium.type "css=input#passwordField", (rand(10000000)+10000).to_s
	@selenium.click "css=button#signupButton"
	sleep 1
	begin
        assert_equal title, @selenium.get_title, "Unable to verify social registration prevented a user from creating an account with a username containing invalid characters (underscore)" 
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_text_present("Username contains invalid characters."), "Unable to verify 'Username contains invalid characters' (for underscore char) warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY WHITESPACE IS INVALID CHAR IN USERNAME AND E-MAIL
	@selenium.type "css=input#usernameField", "a"+(rand(10000000)+100).to_s+" i"
	@selenium.type "css=input#emailField", "hel lo"+(rand(1000)+100).to_s+"@com.com"
	@selenium.type "css=input#passwordField", (rand(10000000)+10000).to_s
	@selenium.click "css=button#signupButton"
	sleep 1
	begin
        assert_equal title, @selenium.get_title, "Unable to verify social registration prevented a user from creating an account with a username containing invalid characters (white space)" 
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_text_present("Username contains invalid characters."), "Unable to verify 'Username contains invalid characters' (white space) warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end	
	begin
        assert @selenium.is_text_present("Email address is invalid."), "Unable to verify 'Email address is invalid' (white space) warning appeared in social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end	
	
	# VERIFY CAPTCHA WORKS
	@selenium.type "css=input#usernameField", "a"+(rand(10000000)+100).to_s
	@selenium.type "css=input#emailField", "hello"+(rand(10000000)+100).to_s+"@hello.com"
	@selenium.type "css=input#passwordField", (rand(10000000)+10000).to_s
	@selenium.click "css=button#signupButton"
	sleep 3
	begin
        assert_equal title, @selenium.get_title, "Unable to verify social registration prevented a user from bypassing Captcha"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_text_present("Please enter the two words shown in the box"), "Unable to verify 'Please enter the two words shown in the box' Captcha warning appeared social registration"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	register_post
	
  end
end