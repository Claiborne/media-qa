require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "social" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_social.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to home" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign}/home") 
   page.validate
  end

  it "should respond to settings" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign}/settings")    
   page.validate
  end

  it "should respond to help" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign}/help")    
   page.validate
  end

  it "should respond to home" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign}/home")    
   page.validate
  end

  it "should respond to peer" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign_people}/peer-ign")    
   page.validate
  end

  it "should respond to peer games" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign_people}/peer-ign/games")    
   page.validate
  end

  it "should respond to peer people" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl_myign_people}/peer-ign/people")    
   page.validate
  end

end

