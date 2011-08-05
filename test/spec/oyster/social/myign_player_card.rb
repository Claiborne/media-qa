require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social/login_page'
require 'social/my_profile_page'
require 'social/registration_page'
require 'json'
require 'net/http'


describe "My IGN Player Card" do

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s

	#Set intance vars
	@reg = Oyster::Social::RegistrationPage.new @browser.client, @config
	@email_val = @reg.set_email
	@password_val = @reg.set_pass
	@username_val = @reg.set_user
	
	#Do basic test setup: create a new My IGN account
    @reg.register_post(@email_val, @password_val, @username_val)
    
    @browser.shutdown 
  end
  
  before(:each) do
    @browser = Browser.new
	@login_page = Oyster::Social::LoginPage.new @browser.client, @config
	@myprofile = Oyster::Social::MyProfilePage.new @browser.client, @config
    
    @login_page.visit
    @login_page.signin(@email_val, @password_val)
    @myprofile.visit(@username_val)
    
    #@login_page.signin("smoketest@testign.com", "testpassword")
    #@myprofile.visit("clay.ign")
  end

  after(:each) do
    @browser.shutdown   
  end
  
  it "should generate a new activity in user's newsfeed" do
	@myprofile.create_new_psn_gamercard.should be_true
  end
  
  it "should display pagination after the fourth gamer card" do
  	@myprofile.create_four_gamer_cards.should be_true
  end
  
  it "should edit a gamer card's name" do
	@myprofile.edit_gamer_card.should be_true
  end
  
  it "should delete a gamer card" do
	@myprofile.delete_a_gamercard.should be_true
  end
end