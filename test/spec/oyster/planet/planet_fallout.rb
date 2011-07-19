require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "planet fallout" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_planet_fallout
.yml"
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

  it "should respond to articles 1700" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/static/1700/Fallout-New-Vegas-Interactive-Map")
   page.validate
  end

  it "should respond to articles videos" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos")
   page.validate
  end

  it "should respond to articles videos 568806" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/game/568806/PC/Fallout-3")
   page.validate
  end

  it "should respond to images" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images")
   page.validate
  end

  it "should respond to images 3001" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/game/3001/PC/Fallout")
   page.validate
  end

  it "should respond to images 48" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/48/PC/Fallout/Screenshots/World-map")
   page.validate
  end

  it "should respond to polls" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/polls")
   page.validate
  end

  it "should respond to polls 73" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/poll/73/Platforms")
   page.validate
  end

  it "should respond to top contributors" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/top-contributors")
   page.validate
  end

  it "should respond to users" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/users/231877371/junxing")
   page.validate
  end

  it "should respond to mods list" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/mods/list/")
   page.validate
  end

  it "should respond to mods 439" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/mods/439/100-Repair-Ammo-Npc")
   page.validate

  it "should respond to mods add" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/mods/add")
   page.validate

  it "should respond to maps" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/maps/1/Capital-Wasteland/")
   page.validate

  it "should respond to wiki" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wiki")
   page.validate

  it "should respond to wiki obsidian" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wiki/Obsidian_Entertainment")
   page.validate
end
~                                                                             
