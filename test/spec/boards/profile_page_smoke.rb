require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'phantom_helpers/sign_in'; include SignIn

describe 'Boards - Smoke Test Profile Information', :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/boards.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  context 'Sign In' do
    sign_in('/boards/')
  end

  describe 'Main Page' do

    context 'User Info Overlay' do

      it "should appear when their avatar in the sidebar is clicked'" do
        @selenium.find_element(:css => 'a.avatar img').click
        @wait.until { @selenium.find_element(:css => 'div.xenOverlay.memberCard').displayed? }
      end

      it "should display the user's avatar" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard div.avatarCropper img[src='http://oystatic.ignimgs.com/src/core/img/social/avatars/system/baseball.jpg']").displayed?.should be_true
      end

      it "should display the user's username" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard h3.username").displayed?.should be_true
        @selenium.find_element(:css => "div.xenOverlay.memberCard h3.username").text.should == 'Clay.IGN'
      end

      it "should display 'Prime Member' below the user's name" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard h4.userTitle").displayed?.should be_true
        @selenium.find_element(:css => "div.xenOverlay.memberCard h4.userTitle").text.should == 'Prime Member'
      end

      it "should display the user's correct 'member since' date" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard dl.userStats.pairsInline dd").displayed?.should be_true
        @selenium.find_element(:css => "div.xenOverlay.memberCard dl.userStats.pairsInline dd").text.should == "Mar 11, 2011"
      end

      it "should display some text for the user's last MyIGN status update'" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard div.userInfo blockquote").displayed?.should be_true
        @selenium.find_element(:css => "div.xenOverlay.memberCard div.userInfo blockquote").text.delete('^a-z').length.should > 0
      end

      it "should display some 'last seen' description" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard dl.pairsInline.lastActivity dd").displayed?.should be_true
        @selenium.find_element(:css => "div.xenOverlay.memberCard dl.pairsInline.lastActivity dd").text.delete('^a-z').length.should > 0
      end

      it "should open the user's profile page when their name is clicked" do
        @selenium.find_element(:css => "div.xenOverlay.memberCard h3.username a").click
        @wait.until { @selenium.current_url.match(/members\/clay-ign/) }
      end

    end

  end

  describe 'User Profile Page' do

    context 'Global Header and Nav' do
      check_global_header_nav
      check_header_signed_in
    end

    context 'Page' do

      it "should display the user's avatar image" do
        @selenium.find_element(:css => "div.profilePage div.avatarScaler img").displayed?.should be_true
        @selenium.find_element(:css => "div.profilePage div.avatarScaler img").attribute('src').should == "http://oystatic.ignimgs.com/src/core/img/social/avatars/system/baseball.jpg"
      end

      it "should display the user's username" do
        @selenium.find_element(:css => "div.main h1").text.should == 'Clay.IGN'
      end

      it "should display 'Prime Member' below the user's name" do
        @selenium.find_element(:css => "div.main span.userTitle").text.should == 'Prime Member'
      end

      it "should display the user has at least one follower" do
        @selenium.find_element(:css => 'div.followBlocks h3 a').text.to_i.should > 0
      end

      it "should display at least one follower's avatar" do
        @selenium.find_element(:css => "div.followBlocks div.avatarHeap a.avatar img[src*='http']").displayed?.should be_true
      end

    end

  end

end
