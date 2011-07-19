require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "grand theft auto" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_grand_theft_auto.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to home" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/")                         
   page.validate
  end

  it "should respond to articles" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles")                         
   page.validate
  end

  it "should respond to articles 5565" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/news/5565/Red-Dead-Redemption-Swag-Gallery")                         
   page.validate
  end

  it "should respond to videos" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos")                         
   page.validate
  end

  it "should respond to video 16137" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/game/16137/Xbox/Grand-Theft-Auto-Double-Pack")                         
   page.validate
  end

  it "should respond to images" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images")                         
   page.validate
  end

  it "should respond to image 827005" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/game/827005/Xbox-360/Grand-Theft-Auto-IV")                         
   page.validate
  end

  it "should respond to image 35283 " do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/35283/PC/Grand-Theft-Auto/Screenshots/Liberty-City-in-GTA-1997")                         
   page.validate
  end

  it "should respond to polls" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/polls")                         
   page.validate
  end

  it "should respond to poll 263" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/poll/263/Red-Dead-Redemption")                         
   page.validate
  end

  it "should respond to top contributors" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/top-contributors")                         
   page.validate
  end

  it "should respond to user" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/users/59979432/Mr-Pants")                         
   page.validate
  end

  it "should respond to missions" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/missions")                         
   page.validate
  end

  it "should respond to mission 286" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/missions/286/Coming-Down")                         
   page.validate
  end

  it "should respond to mission edit" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/missions/edit/286")                         
   page.validate
  end

  it "should respond to missions add" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/missions/add/")                         
   page.validate
  end

  it "should respond to maps" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/maps/1/Liberty-City-Map")                         
   page.validate
  end

  it "should respond to wiki" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wiki")                         
   page.validate
  end

  it "should respond to wiki friends" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wiki/GTA_IV_Friends_&_Girlfriends")                         
   page.validate
  end
end
