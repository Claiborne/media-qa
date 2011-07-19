re File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "ipl" do

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

  it "should respond to ipl" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl")                         
   page.validate
  end

  it "should respond to ipl videos" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/videos")                         
   page.validate
  end

  it "should respond to qualifier" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/videos/2011/07/13/ipl-s2-qualifier-2-round-of-16-white-ra-vs-milllalush-game-1-of-5")                         
   page.validate
  end

  it "should respond broadcast schedule" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/starcraft2/broadcast-schedule")                         
   page.validate
  end

  it "should respond to starcraft 2 tournaments " do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/starcraft2/tournaments")                         
   page.validate
  end

  it "should respond to sc2 brackets" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/starcraft2/brackets")                         
   page.validate
  end

  it "should respond to sc2 players" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/starcraft2/players")                         
   page.validate
  end

  it "should respond to ipl news" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/news")                         
   page.validate
  end

  it "should respond to ipl news commentary" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/news/2011/04/13/pro-commentary-videos-with-players-and-casters")                         
   page.validate
  end

  it "should respond to about" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/ipl/about")                         
   page.validate
  end
end
