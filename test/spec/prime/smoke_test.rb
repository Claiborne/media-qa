require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'
require 'prime'

describe "prime" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/prime/prime.yml"
    @config = Configuration.new  
  end
  
  before(:each) do
   @browser = Browser.new
   @selenium = @browser.client
   
   @signup = SignupPage.new(@selenium, @config)  
   
   @time = Time.now.to_i
  end

  after(:each) do
    @browser.shutdown    
  end
  
#  it "should delete all credit cards" do
#    @selenium.open('http://dev.sysadmin.gamespy.com/billing/AccountsPaymentech/Search.aspx')
#    sleep 30
#    @selenium.type('_ctl0_PageBody_lastFourTextBox', '5557')
#    @selenium.click('_ctl0_PageBody_deletedRadioButtonList_1')
#    @selenium.click('_ctl0_PageBody_activeRadioButtonList_0')
#    @selenium.click('_ctl0_PageBody_searchButton')
#    @selenium.wait_for_element('_ctl0_PageBody_resultsDataGrid__ctl0')
#    x=2
#    for i in 2..201
#      @selenium.click("//td[@id='_ctl0_PageBody_resultsDataGrid__ctl#{x}__ctl1']/a")
#      @selenium.wait_for_element('_ctl0_PageBody_deletedDropDownList')
#      @selenium.select('_ctl0_PageBody_deletedDropDownList', 'Yes')
#      @selenium.select('_ctl0_PageBody_activeDropDownList1', 'No')
#      @selenium.click('_ctl0_PageBody_updateButton')
#      @selenium.wait_for_page_to_load('30000')
#      if @selenium.is_text_present('CustomerProfileMessage: Error validating card/account number range')
#        x = x+1
#      end
#      @selenium.open('http://dev.sysadmin.gamespy.com/billing/AccountsPaymentech/Search.aspx')
#      @selenium.type('_ctl0_PageBody_lastFourTextBox', '5557')
#      @selenium.click('_ctl0_PageBody_deletedRadioButtonList_1')
#      @selenium.click('_ctl0_PageBody_activeRadioButtonList_0')
#      @selenium.click('_ctl0_PageBody_searchButton')
#      @selenium.wait_for_element('_ctl0_PageBody_resultsDataGrid__ctl0')
#    end
#  end
  
  it "should have 3 subscription offerings" do
    @signup.open
    @signup.wait_for_element("//ul[@id='chooseplan']/li")
    for i in 1..3
      @signup.assert_element("//ul[@id='chooseplan']/li[#{i}]").should be_true
    end
  end  
  
  it "should not have more than 3 subscription offerings" do
    @signup.open
    @signup.assert_element("//ul[@id='chooseplan']/li[4]").should be_false
  end
  
  it "should allow a user to login" do
    @signup.open
    @signup.login({
      :email    => "fklun@ign.com",
      :password => "boxofass"
    })
    @signup.assert_text('You are logged in.').should be_true
  end
  
  it "should fail with incorrect credentials" do
    @signup.open
    @signup.login({
      :email    => "fklun@ign.com",
      :password => "thewrongpassword"
    })
    @signup.assert_text('Account not found.').should be_true
    @signup.assert_text('You awefare logged in.').should be_false
  end
  
  it "should have 5 payment methods" do
    @signup.open
    for i in 1..6
      @signup.assert_element("//p[@class='clear margintb-10']/a[#{i}]").should be_true
    end
  end
  
  it "should not have more than 5 payment methods" do
    @signup.open
    @signup.assert_element("//p[@class='clear margintb-10']/a[7]").should be_false
  end
  
  it "should allow a new user to complete a purchase" do
    @signup.open
    @signup.register({
        :email =>     "fklun_#{@time}@ign.com",
        :password =>  "boxofass",
        :nickname =>  "fklun_#{@time}"
    })

    @signup.fill_CC_details({
      :card_num         => @signup.generate_card_num('Mastercard'),
      :card_cvv         => @signup.generate_random_cvv,
      :first_name       => 'Frank',
      :last_name        => 'Klun',
      :street_address   => '3070 Bristol St.',
      :city             => 'Costa Mesa',
      :card_zip         => @signup.generate_random_zip,
      :card_month       => @signup.generate_random_month,
      :card_year        => @signup.generate_random_year
    })
    
    @signup.complete_order.should be_true
    @signup.validate_order("fklun_#{@time}").should be_true
  end
end