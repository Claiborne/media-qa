require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social'
require 'social/settings_page'
require 'social/my_profile_page'

describe "social authentication" do
  def initialize_do_not_follow(people_page,user,pwd,person)

  end

  def initialize_unmark_privacy(settings_page,user,pwd)

  end

  before(:all) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
   @config = Configuration.new


  end

  before(:each) do
    @browser = Browser.new

  end

  after(:each) do
   @browser.shutdown
  end

  it "should write on someone's wall that I am not following and has privacy settings turned off" do

   test_user = "ign1.qa@gmail.com"
   test_password = "igntest123"
   not_following_user = "ign10.qa@gmail.com"
   not_following_password = "igntest123"

   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   settings_page = Oyster::Social::SettingsPage.new @browser.client, @config
   
   #initialize
   ign_login_page.visit
   ign_login_page.signin(not_following_user, not_following_password)

   @browser.client.click("css=a:contains('Settings')")
   @browser.client.wait_for_page_to_load
      
   settings_page.unmark_privacy_setting
   @browser.client.open "http://people.ign.com/ign1.qa"
   @browser.client.wait_for_page_to_load
   my_profile_page.stop_following_person
   
   @browser.client.click("css=a:contains('Sign Out')")

   @browser.client.wait_for_page_to_load
   ign_login_page.visit
   ign_login_page.signin(test_user, test_password)
   @browser.client.open "http://people.ign.com/goigngo"
   @browser.client.wait_for_page_to_load

   #actual test
   my_profile_page.stop_following_person
   my_profile_page.is_wall_post_entry_available?.should be_true
   @browser.client.click("css=a:contains('Sign Out')")
   
  end

  it "should write on someone's wall that I am following and has privacy settings turned off" do
   test_user = "ign1.qa@gmail.com"
   test_password = "igntest123"
   not_following_user = "ign10.qa@gmail.com"
   not_following_password = "igntest123"

   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   settings_page = Oyster::Social::SettingsPage.new @browser.client, @config

   #initialize
   ign_login_page.visit
   ign_login_page.signin(not_following_user, not_following_password)

   @browser.client.click("css=a:contains('Settings')")
   @browser.client.wait_for_page_to_load

   settings_page.unmark_privacy_setting
   @browser.client.open "http://people.ign.com/ign1.qa"
   @browser.client.wait_for_page_to_load
   my_profile_page.stop_following_person
   
   @browser.client.click("css=a:contains('Sign Out')")

   @browser.client.wait_for_page_to_load
   ign_login_page.visit
   ign_login_page.signin(test_user, test_password)
   @browser.client.open "http://people.ign.com/goigngo"
   @browser.client.wait_for_page_to_load

   #actual test
   
   my_profile_page.start_following_person
   my_profile_page.is_wall_post_entry_available?.should be_false
   @browser.client.click("css=a:contains('Sign Out')")

  end

  it "should not be able to write on someone's wall that I am not following and has privacy settings turned on" do

   test_user = "ign1.qa@gmail.com"
   test_password = "igntest123"
   not_following_user = "ign10.qa@gmail.com"
   not_following_password = "igntest123"

   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   settings_page = Oyster::Social::SettingsPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config

   ign_login_page.visit
   ign_login_page.signin(not_following_user, not_following_password)

   @browser.client.click("css=a:contains('Settings')")
   @browser.client.wait_for_page_to_load
   
   
   settings_page.mark_privacy_setting
   @browser.client.open "http://people.ign.com/ign1.qa"
   @browser.client.wait_for_page_to_load
   my_profile_page.stop_following_person
   @browser.client.click("css=a:contains('Sign Out')")
   @browser.client.wait_for_page_to_load

   ign_login_page.visit
   ign_login_page.signin(test_user, test_password)
   @browser.client.open "http://people.ign.com/goigngo"
   @browser.client.wait_for_page_to_load

   
   my_profile_page.stop_following_person
   my_profile_page.is_wall_post_entry_available?.should be_false
   @browser.client.click("css=a:contains('Sign Out')")
   
  end

  it "should not be able to write on someone's wall that I am following and has privacy settings turned on" do

   test_user = "ign1.qa@gmail.com"
   test_password = "igntest123"
   not_following_user = "ign10.qa@gmail.com"
   not_following_password = "igntest123"

   ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   settings_page = Oyster::Social::SettingsPage.new @browser.client, @config

   ign_login_page.visit
   ign_login_page.signin(not_following_user, not_following_password)

   @browser.client.click("css=a:contains('Settings')")
   @browser.client.wait_for_page_to_load
   

   settings_page.mark_privacy_setting
   @browser.client.open "http://people.ign.com/ign1.qa"
   @browser.client.wait_for_page_to_load
   my_profile_page.stop_following_person
   @browser.client.click("css=a:contains('Sign Out')")
   @browser.client.wait_for_page_to_load
   ign_login_page.visit
   ign_login_page.signin(test_user, test_password)
   @browser.client.open "http://people.ign.com/goigngo"
   @browser.client.wait_for_page_to_load

   my_profile_page.is_wall_post_entry_available?.should be_false
   @browser.client.click("css=a:contains('Sign Out')")

  end
end


