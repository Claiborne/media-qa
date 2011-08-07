require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social/registration_page'
require 'social/login_page'
require 'social/my_profile_page'
require 'json'
require 'net/http'

describe "My IGN New Account Creation" do

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
	
	@reg = Oyster::Social::RegistrationPage.new @browser.client, @config
	@login_page = Oyster::Social::LoginPage.new @browser.client, @config
	@myprofile = Oyster::Social::MyProfilePage.new @browser.client, @config
	@selenium = @browser.client
	
	#Set intance vars
	@email_val = @reg.set_email
	@password_val = @reg.set_pass
	@username_val = @reg.set_user
  end

  after(:all) do
    @browser.shutdown    
  end

  it "should create a new account via the API" do
    resp_body = @reg.register_post(@email_val, @password_val, @username_val)
    /ErrorMessage":null/.should =~ resp_body
 	/Status":1/.should =~ resp_body
 	/Status":3/.match(resp_body).should be_nil
 	/Status":4/.match(resp_body).should be_nil
 	/Status":5/.match(resp_body).should be_nil
 	/Status":8/.match(resp_body).should be_nil
    sleep 7
  end


  it "should login and land on the cold start header" do
    @login_page.visit
    @login_page.signin(@email_val, @password_val)
	@selenium.is_text_present("Follow your friends and the top upcoming games on IGN and be the first to know when the news breaks!").should be_true
  end

  it "should generate the following activity in user's newsfeed: level 2" do
	@myprofile.visit(@username_val)
	sleep 5
	@selenium.get_text("css=div#bodyModulesContainer").match(/achieved level 2!/).should be_true
  end
  
  it "should generate the following activity in user's newsfeed: joined community" do
	@selenium.get_text("css=div#bodyModulesContainer").match(/joined the community/).should be_true
  end
end  