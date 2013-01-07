require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'
require 'prime'

describe "prime" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/prime/prime.yml"
    @config = PathConfig.new
  end
  
  before(:each) do
   @browser = Browser.new
   @selenium = @browser.client
   
   @signup_page = SignupPage.new(@selenium, @config)

   @time = Time.now.to_i
  end

  after(:each) do
    @browser.shutdown    
  end

  it "should have 3 subscription offerings" do
    @signup_page.open
    @signup_page.wait_for_element("//ul[@id='chooseplan']/li")
    for i in 1..3
      @signup_page.assert_element("//ul[@id='chooseplan']/li[#{i}]").should be_true
    end
  end  
  
  it "should not have more than 3 subscription offerings" do
    @signup_page.open
    @signup_page.assert_element("//ul[@id='chooseplan']/li[4]").should be_false
  end
  
  it "should allow a user to login" do
    @signup_page.open
    @signup_page.login({
      :email    => "fklun@ign.com",
      :password => "boxofass"
    })
    @signup_page.wait
    @signup_page.assert_text('You are logged in.').should be_true
  end
  
  it "should fail with incorrect credentials" do
    @signup_page.open
    @signup_page.login({
      :email    => "fklun@ign.com",
      :password => "thewrongpassword"
    })
    @signup_page.assert_text('Account not found.').should be_true
    @signup_page.assert_text('fereger').should be_false
  end
  
  it "should have 5 payment methods" do
    @signup_page.open
    for i in 1..6
      @signup_page.assert_element("//p[@class='clear margintb-10']/a[#{i}]").should be_true
    end
  end
  
  it "should not have more than 5 payment methods" do
    @signup_page.open
    @signup_page.assert_element("//p[@class='clear margintb-10']/a[7]").should be_false
  end
  
  it "should allow a new user to complete a purchase" do
    @signup_page.open
    @signup_page.register({
        :email =>     "fklun_#{@time}@ign.com",
        :password =>  "boxofass",
        :nickname =>  "fklun_#{@time}"
    })
    @signup_page.fill_CC_details({
      :card_num         => @signup_page.generate_card_num('Mastercard'),
      :card_cvv         => @signup_page.generate_random_cvv,
      :first_name       => 'Frank',
      :last_name        => 'Klun',
      :street_address   => '3070 Bristol St.',
      :city             => 'Costa Mesa',
      :card_zip         => @signup_page.generate_random_zip,
      :card_month       => @signup_page.generate_random_month,
      :card_year        => @signup_page.generate_random_year
    })
    
    @signup_page.complete_order.should be_true
    @signup_page.validate_order("fklun_#{@time}").should be_true
  end
  
  it "should allow a user to disable ads" do
    login_page = LoginPage.new(@selenium, @config)
    
    login_page.disable_ads_on_ign.should be_true
    login_page.disable_ads_on_fileplanet.should be_true
    login_page.disable_ads_on_gamespy.should be_true
  end
end