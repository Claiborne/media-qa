require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "layout"

class GuiTesting < Test::Unit::TestCase
  
  def setup
    Page.errors = []
    Browser.config_path = "../config/selenium.yml"
    @browser = Browser.new
    
    time = CustomTime.new
    @int_time = time.get_int_time
    #@xml_log = XMLog.open('CheckoutCreditCard')
  end

  def teardown
    @browser.shutdown()
    assert_equal [], Page.errors
    #XMLog.close('CheckoutCreditCard')
  end
  
  def test_capture_subscribe_page
    subscribe_page = SubscribePage.new
    subscribe_page.client = @browser.client
    subscribe_page.visit("subscribe/signup.aspx")
    sleep 2
    subscribe_page.take_screenshot("IGN Prime", "2", "subscribe page", "firefox3", "subscribe_page_default_top")
    subscribe_page.key_press("id=main", "\34")
    sleep 5
    
    
  end
  
end