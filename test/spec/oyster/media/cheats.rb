require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "cheats" do

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

  it "should respond to home" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/cheats/")                         
   page.validate
  end

  it "should respond to cheats list" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/cheats/list")                         
   page.validate
  end

  it "should respond to pokemon cheats" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/cheats/games/pokemon-black-version-nds-59687")                         
   page.validate
  end`
end
~                                                                             
~            
