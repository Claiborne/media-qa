require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social'
require 'social/newsfeed_page'
require 'social/my_profile_page'
require 'ign_page_types/game_object_page'

describe "Follow Game" do

  before(:all) do
   
   @user = "ign1.qa@gmail.com"
   @password = "igntest123"
   @follower_user = "ign10.qa@gmail.com"
   @follower_password = "igntest123"
   @video_url = 'http://ps3.ign.com/objects/142/14273490.html'
  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
   @config = Configuration.new
   @browser = Browser.new
   @ign_login_page = Oyster::Social::LoginPage.new @browser.client, @config
   @game_object_page = Oyster::IGN::GameObjectPage.new @browser.client, @config
   @my_profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
   @timestamp = Time.now.to_i

  end

  after(:each) do
   @browser.client.open @video_url
   @browser.client.wait_for_page_to_load
   if(@browser.client.get_title.include?("Advertisement"))
      @browser.client.click("css=a")
      @browser.client.wait_for_page_to_load "40"
   end
   @game_object_page.stop_following_game

   @browser.shutdown
  end

  it "should redirect to games list when logged in and adding game" do


     #actual test
     @ign_login_page.visit
     @ign_login_page.signin(@user,@password)
     @browser.client.open @video_url
     @browser.client.wait_for_page_to_load
     if(@browser.client.get_title.include?("Advertisement"))
        @browser.client.click("css=a")
        @browser.client.wait_for_page_to_load "40"

     end

     @game_object_page.start_following_game
     @game_object_page.is_following?.should be_true
     @game_object_page.manage_game
     title = @browser.client.get_title
     puts title
     title.should match /Game Collection & Wishlist/
  end

  it "should redirect to my ign home page when not logged in" do


     #actual test
     @browser.client.open @video_url
     @browser.client.wait_for_page_to_load
     if(@browser.client.get_title.include?("Advertisement"))
        @browser.client.click("css=a")
        @browser.client.wait_for_page_to_load "40"

     end

     @game_object_page.start_following_game
     @browser.client.is_element_present("css=div.myIgnGetStarted").should be_true
     
  end

  it "should show 'follow' button after clicking the remove button" do


     #actual test
     @ign_login_page.visit
     @ign_login_page.signin(@user,@password)
     @browser.client.open @video_url
     @browser.client.wait_for_page_to_load
     if(@browser.client.get_title.include?("Advertisement"))
        @browser.client.click("css=a")
        @browser.client.wait_for_page_to_load "40"

     end

     @game_object_page.start_following_game
     @browser.client.refresh
     @browser.client.wait_for_page_to_load "30"
     @game_object_page.stop_following_game
     @game_object_page.is_following?.should be_false
  end

end