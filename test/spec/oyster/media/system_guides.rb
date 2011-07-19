require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "system_guides" do

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

  it "should respond to 3ds system guide" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/system-guides/3ds")                         
   page.validate
  end

  it "should respond to 3ds basics" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/system-guides/3ds/3ds-basics")                         
   page.validate
  end
end
