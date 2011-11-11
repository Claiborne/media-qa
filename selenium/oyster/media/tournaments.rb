require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "tournaments" do

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

  it "should respond to zelda tournament " do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/tournaments/greatest-zelda-game")                         
   page.validate
  end
end
