require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'ign_site'
require 'social/registration_page'
require 'social/login_page'
require 'json'
require 'net/http'

describe "My IGN New Account Creation" do

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
	
	@ign = Oyster::Social::IGN_Site.new @browser.client, @config
	@reg = Oyster::Social::RegistrationPage.new @browser.client, @config
	@login_page = Oyster::Social::LoginPage.new @browser.client, @config
	@selenium = @browser.client
	
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
    @ign.visit "http://#{@baseurl}/login?r=http://#{@baseurl}/"
    if @baseurl.match(/stg-/)
      @login_page.login(@email_val, @password_val)
    else
      @login_page.signin(@email_val, @password_val)
    end
=begin
    @selenium.click "emailField"
    @selenium.type "emailField", @email_val
    @selenium.type "passwordField", @password_val
    @ign.visit_click "signinButton"
=end

	@selenium.is_text_present("Follow your friends and the top upcoming games on IGN and be the first to know when the news breaks!").should be_true
  end

  it "should show two activities: level 2 achieved and joined community" do
	@ign.visit("http://#{@baseurl_people}/#{@username_val}")
	@selenium.get_text("css=div#bodyModulesContainer").match(/achieved level 2!/).should be_true
	@selenium.get_text("css=div#bodyModulesContainer").match(/joined the community/).should be_true
  end
end  