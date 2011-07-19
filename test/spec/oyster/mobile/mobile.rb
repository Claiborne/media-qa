require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "mobile" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_mobile.yml"
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
  
  it "should respond to article 1182019" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/1182019")                         
   page.validate
  end

  it "should respond to mobile cheats" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/games/cheats")                         
   page.validate
  end

  it "should respond to game cheat 611957" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/cheats/games/611957")                         
   page.validate
  end

  it "should respond to mobile game reviews" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/games/reviews")                         
   page.validate
  end

  it "should respond to upcoming games" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/games/upcoming")                         
   page.validate
  end

  it "should respond to game 14304771" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/games/14304771")                         
   page.validate
  end

  it "should respond to mobile videos" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos")                         
   page.validate
  end
end
~                                                                             

