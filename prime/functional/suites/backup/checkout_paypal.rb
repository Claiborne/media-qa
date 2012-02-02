require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "layout"

class CheckoutPayPal < Test::Unit::TestCase
  
  def setup
    Page.errors = []
    Browser.config_path = "../config/selenium.yml"
    @browser = Browser.new
    
    @time = CustomTime.new
    @time = @time.get_int_time
        
    #@xml_log = XMLog.open('CheckoutCreditCard')
  end

  def teardown
    @browser.shutdown()
    assert_equal [], Page.errors
    #XMLog.close('CheckoutCreditCard')
  end
  
  def test_checkout_monthly_paypal
    purchase_steps("PayPal",      "IGN Prime Monthly")
  end
  
  def test_checkout_annual_paypal   
    purchase_steps("PayPal",      "IGN Prime Monthly")
  end

  def test_checkout_biannual_paypal
    purchase_steps("PayPal",      "IGN Prime Monthly")
  end  
  
  #######################################################################
  #
  # Usage: purchase_steps
  #   CC_TYPE - name of the payment option being used at checkout
  #             Valid Options: 
  #                 Visa, 
  #                 Mastercard 
  #                 Amex
  #                 Discover 
  #                 PayPal
  #   PLAN_NAME - name of the subscription being purchased
  #               Valid Options:
  #                 IGN Prime Monthly
  #                 IGN Prime Annual
  #                 IGN Prime Biannual
  #######################################################################
  def purchase_steps(cc_type, plan_name)
    
    #since we are calling @time multiple times per test, we need to add some randomness
    #so we don't accidently get the same number twice
    @time = @time + rand(500)
    
    subscribe_page = SubscribePage.new  #create a new page object for subscribe.aspx
    subscribe_page.client = @browser.client
    
    #if this is a PayPal transaction, we need to log into the developer sandbox first
    if cc_type == 'PayPal'
      subscribe_page.login_developer_site({
        :email    => 'kma@ign.com',
        :password => 'passw0rd'
      })
    end
    subscribe_page.visit("subscribe/signup.aspx")
    sleep 3 #need a short pause to give javascript time to load
    
    #if we see the Log Out text, then we need to log the current user out before
    #we can continue
    if subscribe_page.locate_text('[x] Log Out')
      subscribe_page.logout
    end
    
    subscribe_page.select_subscription_type(plan_name)
    subscribe_page.register_account({
      :email        => "ignprime#{@time}@ign.com",
      :password     => 'boxofass',
      :unique_nick  => "ignprime#{@time}"
    })
    subscribe_page.select_payment_type(cc_type)

    #PayPal and Credit Cards have different purchase flows and require different steps
    if cc_type == 'PayPal'
      subscribe_page.fill_paypal_details({
        :first_name => 'Frank',
        :last_name  => 'Klun',
        :email      => 'kma_a_1242257146_per@ign.com',
        :password   => 'passw0rd' 
      })      
    else
      subscribe_page.fill_creditcard_details({
        :card_num         => subscribe_page.generate_card_num(cc_type),
        :card_cvv         => subscribe_page.generate_random_cvv,
        :first_name       => 'Frank',
        :last_name        => 'Klun',
        :street_address   => '3070 Bristol St.',
        :city             => 'Costa Mesa',
        :card_zip         => subscribe_page.generate_random_zip,
        :card_month       => subscribe_page.generate_random_month,
        :card_year        => subscribe_page.generate_random_year
      })     
    end

    subscribe_page.complete_order
    subscribe_page.assert_progress_page
    subscribe_page.assert_order_success(plan_name, "ignprime#{@time}") 
  end   
end