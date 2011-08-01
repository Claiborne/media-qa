require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social'
require 'providers'

describe "social authentication" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should authenticate existing user with valid credentials" do
   login_page = Oyster::Social::LoginPage.new @browser.client, @config
   login_page.visit 
   login_page.login('ign.luigi@yopmail.com', 'b1x2ff3ss') 
  end

  it "should authenticate facebook user with valid credentials" do
   provider_name = "facebook"
   user = 'media-qa@ign.com'
   pwd =  'b1x2ff3ss'
   user = "ign10.qa@gmail.com"
   pwd = "igntest123"
   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   facebook_login_page = ProviderLoginPage.new @browser.client, @config,provider_name
   ign_login_page.visit
   ign_login_page.login_openid(provider_name)
   facebook_login_page.login(user,pwd)
   
  end

  it "should authenticate google user with valid credentials" do
   provider_name = "google"
   user = 'ign.luigi@gmail.com'
   pwd =  'b1x2ff3ss'
   user = "ign1.qa@gmail.com"
   pwd = "igntest123"
   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   google_login_page = ProviderLoginPage.new @browser.client, @config, provider_name
   ign_login_page.visit
   ign_login_page.login_openid provider_name
   google_login_page.login(user,pwd)
  end

  it "should authenticate yahoo user with valid credentials" do
   provider_name = "yahoo"
   user = 'ign.luigi@yahoo.com'
   pwd = 'b1x2ff3ss'
   user = "bgdulay@yahoo.com"
   pwd = "bgd860"
   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   yahoo_login_page = ProviderLoginPage.new(@browser.client, @config,provider_name)
   ign_login_page.visit
   ign_login_page.login_openid(provider_name)
   yahoo_login_page.login(user,pwd)
  end

  it "should not authenticate google user with invalid credentials" do
    login_page = Oyster::Social::LoginPage.new @browser.client, @config
   login_page.visit
   login_page.login('ign10.qa@gmail.com', 'test123')
   login_page.assert_invalid_authentication_message
  end
end

