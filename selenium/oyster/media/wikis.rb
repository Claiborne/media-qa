require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "wikis" do

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

  it "should respond to la noire wiki" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wikis/la-noire")                         
   page.validate
  end

  it "should respond to la noire recent changes" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wikis/la-noire/recentchanges")                         
   page.validate
  end

  it "should respond to la noire patrol desk" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wikis/la-noire/Patrol_Desk")                         
   page.validate
  end

  it "should respond to patrol desk history" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wikis/la-noire/history/Patrol_Desk")                         
   page.validate
  end

  it "should respond to edit patrol desk" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/wikis/la-noire/edit/Patrol_Desk")                         
   page.validate
  end
end
