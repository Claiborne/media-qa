require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "search" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_search.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to search" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/")                         
   page.validate
  end

  it "should respond to search grand theft auto" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/product?query=grand+theft+auto+iv
")                         
   page.validate
  end
end
