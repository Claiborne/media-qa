require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'open_page'
require 'nokogiri'
require 'open_page'; include OpenPage
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'widget/evo_header'; include EvoHeader
require 'widget/global_footer'; include GlobalFooter

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

describe "Peer-IGN's Profile Page" do

  before(:all) do

    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/people_ign.yml"
    @config = PathConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @page = "http://#{@config.options['baseurl']}/peer-ign" 
    @doc = nokogiri_not_301_open(@page)   
  end
  
  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
  context "Global Header Widget" do
    widget_evo_header
  end
    
  context "Global Footer Widget" do
    widget_global_footer
  end
 
  context "Profile Header" do
        
    it "should display" do
      @doc.css("div#ignSocialHeader div.socialProfileHeader").count.should == 1
    end
    
    it "should display Peer-IGN" do
      @doc.css("div#ignSocialHeader div.socialProfileHeader div.username").text.should == 'Peer-IGN'
    end
    
    it "should display an avatar image" do
      avatar = @doc.css("div#ignSocialHeader div.socialProfileHeader div.avatarFrame img")
      avatar.count.should == 1
      RestClient.get avatar.attribute('src').to_s
    end
    
    it "should display Peer's Xbox Live Player Card" do
      @doc.css("div.socialProfileHeader div.gamerCard li.plat_xbox").text.strip.should == 'PeerIGN'
    end
    
    it "should display stats for following, followers, and games" do
      profile_stats = @doc.css("div.socialProfileHeader ul.profileStats li.counter")  
      profile_stats.count.should == 3
      profile_stats.each do |stats|
        stats.text.strip.length.should > 3
      end
    end
    
    context "Main Content" do
      
      it "should display at least ten activities" do
        main_content = @doc.css("div#bodyModules div#activityStream ul#activityList")  
        main_content.count.should == 1
        activities = main_content.css('li > div.activityBody p')
        activities.count.should > 9
        activities.each do |activity|
          activity.text.strip.gsub(/\s+/,'').length.should > 0
        end
      end
      
    end
    
    context "Right Rail" do
      
      it "should display at least one game followed" do
        @doc.at_css("div#rightRail div.gamesFollowContainer div.gf-thumbContainer a img[src*='http']").should be_true
      end
      
      it "should display at least one person followed" do
        @doc.at_css("div#rightRail div.pf-clusterContainer a img.pf-avatar[src*='http']").should be_true
      end
            
    end
    
  end
  
end

describe "Peer-IGN's Blog Page" do

  before(:all) do

    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @page = "http://#{@config.options['baseurl']}/blogs/peer-ign" 
    @doc = nokogiri_not_301_open(@page)   
  end
  
  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
  context "Global Header Widget" do
    widget_evo_header
  end
    
  context "Global Footer Widget" do
    widget_global_footer
  end
  
  it "should display a header image" do
    @doc.css("div#ignSocialHeader div").attribute('style').to_s.match(/url\('http/).should be_true
  end
  
  it "should display a blog title" do
    @doc.css("div#content div.post a").text.strip.gsub(/\s+/,'').length.should > 1
  end
  
  it "should display blog content" do
    @doc.css("div#content div.post div.entry").text.strip.gsub(/\s+/,'').length.should > 10
  end
  
  it "should display at least two blog entries" do
    @doc.css("div#content div.post a").count.should > 1
    @doc.css("div#content div.post div.entry").count.should > 1
  end
  
  context "Right Rail" do
    
    it "should not be blank" do
      @doc.css("div#sidebar div").count.should > 5
      @doc.css("div#sidebar").text.strip.gsub(/\s+/,'').length.should > 100 # usually > 1,000 in production
    end
    
  end
    
end