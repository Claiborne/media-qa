require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

require "library"

class CheckoutCreditCard < Test::Unit::TestCase
  
  def setup
    Page.errors = []
    Browser.config_path = "config/selenium.yml"
    @browser = Browser.new
    
    @time = CustomTime.new
    @time = @time.get_int_time
    
    @user_email = "ignprime#{@time}@ign.com"
    
    @login_info = {
      :email    => @user_email,
      :password => 'boxofass'
    }
    
    #@xml_log = XMLog.open('CheckoutCreditCard')
  end

  def teardown
    @browser.shutdown()
    assert_equal [], Page.errors
    #XMLog.close('CheckoutCreditCard')
  end

  def test_DisableAdsOnIGN
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_page.visit('http://dev.login.ign.com')
    login_page.login(@login_info)
  
    login_page.disable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'disabled', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'disabled', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'disabled', @login_info)    
    login_page.verify_hub_page('disabled', @login_info)
    #login_page.verify_sub_api('disabled', @user_email)
  end
  

  def test_EnableAdsOnIGN
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_page.visit('http://dev.login.ign.com')
    login_page.login(@login_info)
  
    login_page.disable_ads
    login_page.enable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'enabled', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'enabled', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'enabled', @login_info)    
    login_page.verify_hub_page('enabled', @login_info)
    #login_page.verify_sub_api(disabled)
  end  
  
  def test_DisableAdsOnFileplanet
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_page.visit('http://dev.login.fileplanet.com')
    login_page.login(@login_info)
  
    login_page.disable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'disabled', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'disabled', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'disabled', @login_info)    
    login_page.verify_hub_page('disabled', @login_info)
    #login_page.verify_sub_api(disabled)
  end
  
  def test_EnableAdsOnFileplanet
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_page.visit('http://dev.login.fileplanet.com')
    login_page.login(@login_info)
  
    login_page.disable_ads
    login_page.enable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'enabled', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'enabled', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'enabled', @login_info)    
    login_page.verify_hub_page('enabled', @login_info)
    #login_page.verify_sub_api(disabled)
  end  

  def test_DisableAdsOnGamespy
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_info = {
      :email    => @user_email,
      :password => 'boxofass'
    }
    login_page.visit('http://dev.login.gamespy.com')
    login_page.login(login_info)
  
    login_page.disable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'disabled', login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'disabled', login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'disabled', login_info)    
    login_page.verify_hub_page('disabled', login_info)
    #login_page.verify_sub_api(disabled)
  end
  
  def test_EnableAdsOnGamespy
    login_page = LoginPage.new
    login_page.client = @browser.client
    purchase_steps_ads
    login_page.visit('http://dev.login.gamespy.com')
    login_page.login(@login_info)
  
    login_page.disable_ads
    login_page.enable_ads
    login_page.verify_domains("http://dev.login.ign.com",         'enabled', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'enabled', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'enabled', @login_info)    
    login_page.verify_hub_page('enabled', @login_info)
    #login_page.verify_sub_api(disabled)
  end
  
  def test_DisableAdsOnReceipt
    subscribe_page = SubscribePage.new
    subscribe_page.client = @browser.client
    purchase_steps_ads
    subscribe_page.disable_ads
    
    login_page = LoginPage.new
    login_page.client = @browser.client
    login_page.verify_domains("http://dev.login.ign.com",         'disable', @login_info)
    login_page.verify_domains("http://dev.login.fileplanet.com",  'disable', @login_info)
    login_page.verify_domains("http://dev.login.gamespy.com",     'disable', @login_info)    
    login_page.verify_hub_page('disable', @login_info)
  end
  
  def test_DisableAdsOnHub
    hub_page = HubPage.new
    hub_page.client = @browser.client
    purchase_steps_ads
    hub_page.disable_ads
    hub_page.verify_hub_page('disabled', @login_info)  
  end
  
  def test_EnableAdsOnHub
    hub_page = HubPage.new
    hub_page.client = @browser.client
    purchase_steps_ads
    hub_page.enable_ads
    hub_page.verify_hub_page('enabled', @login_info)  
  end
  
  def purchase_steps_ads
    puts 'user_email is'
    puts @user_email
    subscribe_page = SubscribePage.new  #create a new page object for subscribe.aspx
    subscribe_page.client = @browser.client
    subscribe_page.visit("subscribe/signup.aspx")
    sleep 3 #need a short pause to give javascript time to load
    
    #if we see the Log Out text, then we need to log the current user out before
    #we can continue
    if subscribe_page.locate_text('[x] Log Out')
      subscribe_page.logout
    end
    
    subscribe_page.select_subscription_type('IGN Prime Monthly')
    subscribe_page.register_account({
      :email        => @user_email,
      :password     => 'boxofass',
      :unique_nick  => "ignprime#{@time}"
    })
    subscribe_page.select_payment_type('Amex')
    subscribe_page.fill_creditcard_details({
      :card_num         => '343434343434343',
      :card_cvv         => '5555',
      :first_name       => 'Frank',
      :last_name        => 'Klun',
      :street_address   => '3070 Bristol St.',
      :city             => 'Costa Mesa',
      :card_zip         => '92626',
      :card_month       => '12',
      :card_year        => '2015'
    })

    subscribe_page.complete_order
    subscribe_page.assert_progress_page
    subscribe_page.assert_order_success('IGN Prime Monthly', "ignprime#{@time}")
  end  
end