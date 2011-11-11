require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'

class BlankPageChecker < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*firefox",
      :url => "http://www.ign.com",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_for_blank_page
  
	
	file = File.new("wiki_guides.txt", "r")
	while (guide = file.gets)
		@selenium.open(guide.to_s)
		sleep 4
	end
	file.close
  end
end