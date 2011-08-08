require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social'
require 'social/newsfeed_page'
require 'social/my_profile_page'

describe "social delete button" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
   @config = Configuration.new
   @browser = Browser.new
   @timestamp = Time.now.to_i
  end

  after(:each) do
   @browser.shutdown
  end

  it "should remove post on home page(newsfeed) and My Profile page, from original newsfeed post" do
   msg = "this is a test post #{@timestamp}"
   user = "ign1.qa@gmail.com"
   password = "igntest123"

   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   newsfeed_page  = Oyster::Social::NewsfeedPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   puts "posting: #{msg}"

   ign_login_page.visit
   ign_login_page.signin(user, password)
   newsfeed_page.submit_post(msg)

   newsfeed_page.delete_user_activity_entry(msg)
   @browser.client.refresh
   @browser.client.wait_for_page_to_load
   newsfeed_page.is_user_activity_posted?(msg).should be_false
   @browser.client.click("css=div#ignSocialHeader a:contains('My Profile')")
   @browser.client.wait_for_page_to_load
   my_profile_page.is_user_activity_posted?(msg).should be_false
   #sleep 10
   @browser.client.click("css=a:contains('Sign Out')")
   @browser.client.wait_for_page_to_load

  end


  it "should not be able to remove entries on newsfeed posted by person i am following" do
    msg = "this is a test post #{@timestamp}"
   user = "ign1.qa@gmail.com"
   password = "igntest123"
   following_user = "ign10.qa@gmail.com"
   following_password = "igntest123"

   #initial set up
   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   newsfeed_page  = Oyster::Social::NewsfeedPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   ign_login_page.visit
   ign_login_page.signin(user,password)
   @browser.client.open "http://people.ign.com/goigngo"
   @browser.client.wait_for_page_to_load
   sleep 10
   my_profile_page.start_following_person
   @browser.client.click("css=a:contains('Sign Out')")
   @browser.client.wait_for_page_to_load
   ign_login_page.visit
   ign_login_page.signin(following_user,following_password)

   newsfeed_page.submit_post(msg)
   @browser.client.click("css=a:contains('Sign Out')")
   @browser.client.wait_for_page_to_load
   puts "posted something here"
   #actual test
   ign_login_page.visit
   ign_login_page.signin(user,password)
   @browser.client.click("css=div#activityControl li[class^=showpeople]")
   sleep 5
   newsfeed_page.is_user_activity_posted?(msg).should be_true
   
   
  end
end


