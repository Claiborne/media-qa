require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'

class SocialMyIGNPage < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_myign_page

	@selenium.open "/"
	begin
		assert @selenium.is_element_visible("css=div")
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
end