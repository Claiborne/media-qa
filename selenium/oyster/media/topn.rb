require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "topn" do

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

  it "should respond to top" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/top/ps2-games")                         
   page.validate
  end

  it "should respond to top 100" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/top/ps2-games/100")                         
   page.validate
  end

  it "should respond to top 1" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/top/ps2-games/1")                         
   page.validate
  end
end
