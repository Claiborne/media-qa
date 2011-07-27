require File.dirname(__FILE__) + "/spec_helper"
require 'browser'
require 'prime'

shared_examples_for "Login" do
  it "should allow a user to login" do
    @signup.open
    @signup.click('login')
    @signup.login({
      :email    => "fklun@ign.com",
      :password => 'boxofass',
    })
  end
end

describe "prime" do

  before(:each) do
   @browser = Browser.new
   @selenium = @browser.client
   @signup = SignupPage.new(@selenium)  
  end

  after(:each) do
    @browser.shutdown    
  end
  
  it "should have 3 subscription offerings" do
    @signup.open
    for i in 1..3
      @signup.assert_element("//ul[@id='chooseplan']/li[#{i}]").should be_true
    end
  end  
  
  it "should not have more than 3 subscription offerings" do
    @signup.open
    @signup.assert_element("//ul[@id='chooseplan']/li[4]").should be_false
  end
  
  it "should allow a user to login" do
    it_should_behave_like "Login"
    @signup.assert_text('You are logged in.').should be_true
  end
  
  it "should fail with incorrect credentials" do
    it_should_behave_like "Login"
    @signup.assert_text('You are logged in.').should be_false
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
  
  it "should allow an existing user to choose a payment option" do
    it_should_behave_like "Login"
    
  end
  
end