require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "events" do

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

  it "should respond to events" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/events")                         
   page.validate
  end

  it "should respond to e3" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/events/e3")                         
   page.validate
  end
end
