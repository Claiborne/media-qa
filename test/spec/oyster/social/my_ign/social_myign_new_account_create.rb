require File.dirname(__FILE__) + "/../../../spec_helper"
#require '/../spec/spec_helper.rb'
require 'browser'
require 'social/my_ign/my_ign_mod'
require 'json'
require 'net/http'

describe "My IGN New Account Creation" do
#Note: the following test cases are based on https://wiki.ign-inc.com/display/MediaQA/Regression+Test+Cases

  include My_IGN_Mod

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	@selenium = @browser.client
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
	@email_val = "hello"+(Time.now.to_i).to_s+"@hello.com"
	@password_val = (Time.now.to_i).to_s
	@username_val = "a"+(Time.now.to_i).to_s
  end

  after(:all) do
    @browser.shutdown    
  end
  
  
  it "should create a new account via the API" do
    register_post(@email_val, @password_val, @username_val)
    sleep 7
	#Here's an example of a 'fresh' account for troubleshooting this file
	#user name: qwqwqwqwqwqwqw44
	#Email: williamjclaiborne@xxyyzz.com
  end

  it "should login and land on the cold start header" do
    open("http://#{@baseurl}/login?r=http://#{@baseurl}/")
    @selenium.click "emailField"
    @selenium.type "emailField", @email_val
    @selenium.type "passwordField", @password_val
    click "signinButton"

	@selenium.is_text_present("Follow your friends and the top upcoming games on IGN and be the first to know when the news breaks!").should be_true
  end
  
  it "should " do
	click("css=a[href='http://people.ign.com/#{@username_val}']")
	@selenium.get_text("css=div#bodyModulesContainer").match(/achieved level 2!/).should be_true
	@selenium.get_text("css=div#bodyModulesContainer").match(/joined the community/).should be_true
  end
end  