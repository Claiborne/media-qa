re File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "ve3d" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_ve3d.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end

  it "should respond to home" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/")
   page.validate
  end

  it "should respond to archive" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/news/archive")
   page.validate
  end

  it "should respond to article 55087" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/news/55087/The-Morning-Juberish")
   page.validate
  end

  it "should respond to topics" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/topics")
   page.validate
  end

  it "should respond to topic 657" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/articles/topics/657/Action")
   page.validate
  end

  it "should respond to videos" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos")
   page.validate
  end

  it "should respond to videos game 14243591" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/game/14242591/Xbox-360/50-Cent-Blood-on-the-Sand")
   page.validate
  end

  it "should respond to 50 cent trailer" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/videos/43082/Xbox-360/50-Cent-Blood-on-the-Sand/Trailer/Launch-Trailer")
   page.validate
  end

  it "should respond to images" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images")
   page.validate
  end

  it "should respond to image 1420366" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/game/14240366/Xbox-360/1942-Joint-Strike")
   page.validate
  end

  it "should respond to image 29480" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/images/29480/Xbox-360/1942-Joint-Strike/Screenshots/June-3rd-Screenshot")
   page.validate
  end

  it "should respond to polls" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/polls")
   page.validate
  end

  it "should respond to pools 341" do
   page = Page.new(@browser.client)
   page.visit("http://#{config.options['baseurl}/polls/341/The-Games-of-Summer")
   page.validate
  end
end
~                                                                             
~            
