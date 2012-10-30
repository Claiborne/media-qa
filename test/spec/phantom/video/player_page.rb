require 'rspec'
require 'selenium-webdriver'
require 'configuration'
require 'rest-client'
require 'open_page'
require 'json'
require 'Time'

include OpenPage

######################################################################

%w(/videos/2012/10/19/news-mass-effect-4-wont-star-shepard-2).each do |video_page|
describe "Video Player Page -- #{video_page}", :selenium => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/phantom.yml"
    @config = Configuration.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new
    DataConfiguration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @data_config = DataConfiguration.new

    @page = "http://#{@config.options['baseurl']}#{video_page}"
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)

    data_response = RestClient.get "http://#{@data_config.options['baseurl']}/v3/videos/slug/#{video_page.match(/[^\/]{2,}$/)}"
    @video_data = JSON.parse(data_response.body)

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open #{video_page} on #{ENV['env']}" do
    @selenium.get @page
    @selenium.current_url.should == @page
  end

  it "should display the global header and nav once" do
    @selenium.find_elements(:css => "div#ignHeader div#ignHeader-userBar").count.should == 1
    @selenium.find_element(:css => "div#ignHeader div#ignHeader-userBar").displayed?.should be_true

    @selenium.find_elements(:css => "div#ignHeader div#ignHeader-navigation").count.should == 1
    @selenium.find_element(:css => "div#ignHeader div#ignHeader-navigation").displayed?.should be_true
  end

  it "should display the IGN video player once" do
    @selenium.find_elements(:css => "object#IGNPlayer").count.should == 1
    @selenium.find_element(:css => "object#IGNPlayer").displayed?.should be_true
  end

  it "should display the correct video title" do
    all = @selenium.find_element(:css => "div.video_details div.video_title")
    duration = @selenium.find_element(:css => "div.video_details div.video_title span.video-duration")
    date = @selenium.find_element(:css => "div.video_details div.video_title div.sub-details")

    all.displayed?.should be_true
    duration.displayed?.should be_true
    date.displayed?.should be_true

    all.text.gsub(duration.text,"").gsub(date.text,"").chomp.rstrip.should == @video_data['metadata']['name']
    duration.text.match(/[0-9]{1,2}:[0-9]{2}/).should be_true
    Time.parse(date.text).should == Time.parse(@video_data['metadata']['publishDate'].match(/\d{4}-\d{2}-\d{2}/).to_s)
  end

  it "should display the medrec div once" do
    @selenium.find_elements(:css => "div#sugarad-300x250").count.should == 1
    @selenium.find_element(:css => "div#sugarad-300x250 iframe").displayed?.should be_true
  end

  context "Video Playlist" do

    it "should display the navigation once" do
      @selenium.find_elements(:css => "div.video_playlist_selector").count.should == 1
      @selenium.find_element(:css => "div.video_playlist_selector div").displayed?.should be_true
    end

    it "should display the playlist once" do
      @selenium.find_elements(:css => "div#video_playlist ul").count.should == 1
      @selenium.find_element(:css => "div#video_playlist ul").displayed?.should be_true
    end

    it "should correctly display the navigation text" do
      nav_text = ['RELATED VIDEOS','IGN SHOWS', 'REVIEWS', 'TRAILERS', 'MUST WATCH']
      @selenium.find_element(:css => "div.video_playlist_selector div.item").text.should == 'WATCH:'
      items = @selenium.find_elements(:css => "div.video_playlist_selector a.video_playlist_button div.item")
      items.count.should.should == 5
      items.each_with_index do |val, index|
        val.text.should == nav_text[index]
      end
    end

    #TODO

  end

  context "Disqus Widget" do

    it "should display once" do
      @selenium.find_elements(:css => "div#disqus_thread").count.should == 1
      @selenium.find_elements(:css => "div#disqus_thread iframe").count.should == 4
      @selenium.find_element(:css => "div#disqus_thread iframe").displayed?.should be_true
    end

  end

  context "Video Details (Below Fold)" do

    it "should display the correct video title" do
      @selenium.find_elements(:css => "div#disqus_thread iframe").count.should == 4
      @selenium.find_element(:css => "div#disqus_thread iframe").displayed?.should be_true
    end

  end

  context "Global Footer" do

    it "should display once" do
      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-topRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-topRow").displayed?.should be_true

      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-bottomRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-bottomRow").displayed?.should be_true
    end

  end


end end
