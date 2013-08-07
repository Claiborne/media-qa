require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'open_page'
require 'open_page'; include OpenPage
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav

describe 'My IGN', :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/my_ign.yml"
    @my_config = PathConfig.new
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/people_ign.yml"
    @people_config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"
    @my_base_url = "http://#{@my_config.options['baseurl']}"
    @people_base_url = "http://#{@people_config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym

    @wait = Selenium::WebDriver::Wait.new(:timeout => 7)
  end
  
  after(:all) { @selenium.quit }

  describe "Sign in" do
    
    context "Home page" do
      it "should open" do
        @selenium.get "#@base_url"
        @selenium.current_url.should == "#@base_url/"
      end
    end
    
    context 'Global Header and Nav' do
      check_header_signed_out
      checker_header_signs_in
      check_header_signed_in
    end
    
  end
  
  describe "My IGN Page" do
    
    it "should redirect my.ign.com to /home" do 
      @selenium.get "#@my_base_url"
      @selenium.current_url.should == "#@my_base_url/home"
    end
    
    it "should display the update status text field" do
      @selenium.find_element(:css => "form#updateStatus input#statusField").displayed?.should be_true
    end
    
    it "should display the update status button" do
      @selenium.find_element(:css => "form#updateStatus div#btnUpdateStatus").displayed?.should be_true
    end
    
    it "should display content" do
      my_ign_activity_feed = @selenium.find_elements(:css => "div#activityStream ul#activityList li.activity div.activityBody span.activityContent")    
      my_ign_activity_feed.count.should > 10
      my_ign_activity_feed.each do |activity|
          activity.text.gsub(/\s+/, '').length.should > 5
      end
    end
    
    it "should display the profile-views module" do
      @selenium.find_element(:css => "div#rightRail div.profileViews div.profileViewsHeader").displayed?.should be_true   
      @selenium.find_element(:css => "div#rightRail div.profileViews div.profileViewsHeader").text.match(/Welcome/).should be_true
      @selenium.find_element(:css => "div#rightRail div.profileViews div.profileViewsColContainer div.profileViewsMiddle").displayed?.should be_true   
      @selenium.find_element(:css => "div#rightRail div.profileViews div.profileViewsFooter").displayed?.should be_true    
    end
    
    it "should display at least one game followed" do
       @selenium.find_element(:css => "div#rightRail div.gamesFollowContainer div.gf-row img[src*='http']").displayed?.should be_true   
    end
    
    it "should display at least one people followed" do
      @selenium.find_element(:css => "div#rightRail div.pf-clusterContainer a img[src*='http']").displayed?.should be_true     
    end
    
  end
  
  describe "My Profile Page" do
    
    it "should be linked to in the My IGN nav" do
      @selenium.find_element(:css => "div#ignSocialHeader li.itemLink a[href*='#@people_base_url']").displayed?.should be_true
    end
    
    it "should open" do
      @selenium.find_element(:css => "div#ignSocialHeader li.itemLink a[href*='#@people_base_url']").click
    end
    
    it "should display the user's name" do
      @selenium.find_element(:css => "div.socialProfileHeader div.username").text.gsub(/\s+/,'').length.should > 2  
    end
    
    it "should display the user's avatar" do
      avatar = @selenium.find_element(:css => "div.socialProfileHeader div.avatarFrame img")
      avatar.displayed?.should be_true
      RestClient.get avatar.attribute('src').to_s
    end
    
  end
  
end

describe "Peer-IGN's Profile Page", :selenium => true, :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/my_ign.yml"
    @my_config = PathConfig.new
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/people_ign.yml"
    @people_config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"
    @my_base_url = "http://#{@my_config.options['baseurl']}"
    @people_base_url = "http://#{@people_config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym

    @wait = Selenium::WebDriver::Wait.new(:timeout => 7)
  end
  
  after(:all) { @selenium.quit }
  
  it "should open" do
    @selenium.get "#@people_base_url/peer-ign"
    @selenium.current_url.should == "#@people_base_url/peer-ign" 
  end
  
  context "Profile Header" do
        
    it "should display" do
      @selenium.find_element(:css => "div#ignSocialHeader div.socialProfileHeader").displayed?.should be_true 
    end
    
    it "should display Peer-IGN" do
      @selenium.find_element(:css => "div#ignSocialHeader div.socialProfileHeader div.username").text.should == 'Peer-IGN'
    end
    
    it "should dusplay an avatar image" do
      avatar = @selenium.find_element(:css => "div#ignSocialHeader div.socialProfileHeader div.avatarFrame img")
      avatar.displayed?.should be_true 
      RestClient.get avatar.attribute('src').to_s
    end
  end
  
end