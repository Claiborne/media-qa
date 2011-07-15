require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "widget rendering" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_widget_rendering.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to gamercard default" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/social/people/gamercard/124446?peopleData=")
   page.validate
  end

  it "should respond to gamercard html" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/social/people/gamercard/124446.html?peopleData=")
   page.validate
  end

  it "should respond to gamercard json" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/social/people/gamercard/124446.jsonp?peopleData=")
   page.validate
  end
end

