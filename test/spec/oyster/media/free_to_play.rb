require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "free2play" do

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

  it "should respond to free 2 play" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/free2play")                         
   page.validate
  end
end
