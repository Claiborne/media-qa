require File.dirname(__FILE__) + "/../spec_helper"
require 'browser'
require File.dirname(__FILE__) + "/../../lib/frontpage_example"

describe "IGN frontpage" do

  before(:all) do
   @browser = Browser.new
   @selenium = @browser.client
   front = Frontpage.new(@selenium)
  end

  before(:each) do
  end

  after(:each) do
  end
  
  after(:all) do
    @browser.shutdown
  end

  it "should open the front page" do
   front.open('http://www.ign.com')
  end
  
  it "should have a div present" do
    front.is_element_present("css=div")
  end
end