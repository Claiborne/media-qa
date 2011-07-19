re File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "blogs" do

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

  it "should respond to blogs" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/blogs")                         
   page.validate
  end

  it "should respond to jess blog" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/blogs/jess-ign")                         
   page.validate
  end

  it "should respond to jess love letter" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/blogs/jess-ign/2011/03/07/videogame-industry-my-love-letter-to-you")                         
   page.validate
  end

  it "should respond to blogs gaming" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/blogs/blog/category/gaming")                         
   page.validate
  end
end
~                                                                             
~            
