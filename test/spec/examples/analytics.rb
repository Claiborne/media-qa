require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "analytics" do

  before(:all) do

  end

  before(:each) do
   @browser = Browser.new
   @selenium = @browser.client
  end

  after(:each) do
   @browser.shutdown
  end

  it "should fire analytic events" do
   @selenium.open('http://www.ign.com') 
  end

end
