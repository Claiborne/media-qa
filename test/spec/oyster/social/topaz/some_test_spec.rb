require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social'
require 'social/settings_page'
require 'ign_page_types/game_object_page'

describe "social authentication" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
   @config = Configuration.new
   @browser = Browser.new
   @video_url = 'http://ps3.ign.com/objects/142/14273490.html'
   @game_object_page = Oyster::IGN::GameObjectPage.new @browser.client, @config
  end

  after(:each) do
   @browser.shutdown
  end

  it "should authenticate google user with valid credentials" do

   #actual test
     @browser.client.open @video_url
     @browser.client.wait_for_page_to_load
     if(@browser.client.get_title.include?("Advertisement"))
        @browser.client.click("css=a")
        @browser.client.wait_for_page_to_load "40"

     end

     @game_object_page.start_following_game
     @browser.client.is_element_present("css=div.myIgnGetStarted").should be_true
     
   sleep 10

  end


end


