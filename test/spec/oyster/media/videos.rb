require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "videos" do

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
   page.visit("http://#{config.options['baseurl}/videos")                         
   page.validate
  end

  it "should respond to solar trailer" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/2011/07/14/solar-2-trailer")                         
   page.validate
  end

  it "should respond to daily fix" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/series/ign-daily-fix
")                         
   page.validate
  end
end
