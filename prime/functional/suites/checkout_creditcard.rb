require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "layout"

class CheckoutCreditCard < Test::Unit::TestCase
  
  def setup
    Page.errors = []
    Browser.config_path = "../config/selenium.yml"
    @browser = Browser.new
    #@xml_log = XMLog.open('CheckoutCreditCard')
  end

  def teardown
    @browser.shutdown()
    assert_equal [], Page.errors
    #XMLog.close('CheckoutCreditCard')
  end
  
  def test_checkout_monthly
    purchase_steps("Visa",       "IGN Prime Monthly")
    purchase_steps("Amex",       "IGN Prime Monthly")
    purchase_steps("Mastercard", "IGN Prime Monthly")
    #purchase_steps("Discover",   "IGN Prime Monthly")    
  end
  
  def purchase_steps(cc_type, plan_name)
    
    time = CustomTime.new
    time = time.get_int_time
    
    subscribe_page = SubscribePage.new
    subscribe_page.client = @browser.client
    subscribe_page.visit("subscribe/signup.aspx")
    sleep 3 #need a short pause to give javascript time to load
    if subscribe_page.locate_text('[x] Log Out')
      subscribe_page.logout
    end
    
    subscribe_page.select_subscription_type(plan_name)
    subscribe_page.register_account({
      :email        => "ignprime#{time}@ign.com",
      :password     => 'boxofass',
      :unique_nick  => "ignprime#{time}"
    })
    subscribe_page.select_payment_type(cc_type)

    subscribe_page.fill_creditcard_details({
      :card_num       => subscribe_page.generate_card_num(cc_type),
      :card_cvv       => subscribe_page.generate_random_cvv,
      :firstname      => 'Frank',
      :lastname       => 'Klun',
      :street_address => '3070 Bristol St.',
      :city           => 'Costa Mesa',
      :card_zip       => subscribe_page.generate_random_zip,
      :card_month     => subscribe_page.generate_random_month,
      :card_year      => subscribe_page.generate_random_year
    })
    
    subscribe_page.complete_order
    subscribe_page.assert_progress_page

    subscribe_page.assert_order_success(plan_name, "ignprime#{time}") 
  end   
end