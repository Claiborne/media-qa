require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "video_game_university" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_media.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end
 
  it "should respond to video game university" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/video-game-university")                         
   page.validate
  end
end
