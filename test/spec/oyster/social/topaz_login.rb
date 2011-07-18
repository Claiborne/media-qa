require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'
require 'social'

describe "social authentication" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_social.yml"
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
   login_page = Oyster::Social::LoginPage.new @browser.client, @config
   login_page.visit
   login_page.login_openid('facebook')
   login_page.login('media-qa@ign.com', 'b1x2ff3ss')
  end

  it "should authenticate google user with valid credentials" do
   login_page = Oyster::Social::LoginPage.new @browser.client, @config
   login_page.visit
   login_page.login_openid('google')
   login_page.login('ign.luigi@gmail.com', 'b1x2ff3ss')
  end

  it "should authenticate yahoo user with valid credentials" do
   login_page = Oyster::Social::LoginPage.new @browser.client, @config
   login_page.visit
   login_page.login_openid('yahoo')
   login_page.login('ign.luigi@yahoo.com', 'b1x2ff3ss')
  end
end

