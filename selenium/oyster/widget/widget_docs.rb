require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "widget docs" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_widgets.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to widget docs" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/") 
   page.validate
  end

  it "should respond to widget gamercard" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/social/people/gamercard")        
   page.validate
  end

end

