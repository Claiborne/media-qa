require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'ign_site'
require 'json'
require 'net/http'

describe "My IGN New Account Creation" do

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	@selenium = @browser.client
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
	
	@ign = Oyster::Social::IGN_Site.new @browser.client, @config
	
	#set_new_account_vars
  end

  after(:all) do
    @browser.shutdown    
  end
  
  it "should do something" do
  @ign.visit "/"
  @ign.visit_click "css=a"
  @ign.is_element_present "//div"
  end
=begin
  it "should create a new account via the API" do
    register_post(@email_val, @password_val, @username_val)
    sleep 7
  end

  it "should login and land on the cold start header" do
    open("http://#{@baseurl}/login?r=http://#{@baseurl}/")
    @selenium.click "emailField"
    @selenium.type "emailField", @email_val
    @selenium.type "passwordField", @password_val
    click "signinButton"

	@selenium.is_text_present("Follow your friends and the top upcoming games on IGN and be the first to know when the news breaks!").should be_true
  end
  
  it "should show two activities: level 2 achieved and joined community" do
	click("css=a[href='http://people.ign.com/#{@username_val}']")
	@selenium.get_text("css=div#bodyModulesContainer").match(/achieved level 2!/).should be_true
	@selenium.get_text("css=div#bodyModulesContainer").match(/joined the community/).should be_true
  end
=end
end  