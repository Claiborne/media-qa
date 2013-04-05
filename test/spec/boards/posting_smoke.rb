require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'phantom_helpers/sign_in'; include SignIn

describe 'Boards - Smoke Test for Posting', :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/boards.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  context 'Sign In', :s => true do
    sign_in('/boards/')
  end

  describe "Main Page" do

    context 'Global Header and Nav' do
      check_global_header_nav
      check_header_signed_in
    end

    context 'Main Section' do
      check_main_section_list
      check_main_section_links
    end

    context 'Sidebar Online Now Modules' do
      check_sidebar_online_now
    end

    context 'Sidebar Forum Stats' do
      check_sidebar_forum_stats
    end

    context 'Post New Thread' do

      it 'should open the My IGN topic index when clicked' do
        @selenium.find_element(:css => "ol.sectionMain").find_element(:link_text => "My IGN").click
        @selenium.find_element(:css => 'h1').text.should == 'My IGN'
        @selenium.current_url.match(/my-ign.80149/)
      end

      context 'Index Page for My IGN Topic' do

        it "should display the top 'post new thread' button " do
          @selenium.find_element(:css => "div.breadBoxTop a.callToAction[href*='my-ign.80149/create-thread']").displayed?.should be_true
          @selenium.find_element(:css => "div.breadBoxTop a.callToAction[href*='my-ign.80149/create-thread'] span").text.should == 'Post New Thread'
        end

        it "should display the bottom 'post new thread' button " do
          @selenium.find_element(:css => "div.pageNavLinkGroup a.callToAction[href*='my-ign.80149/create-thread']").displayed?.should be_true
          @selenium.find_element(:css => "div.pageNavLinkGroup a.callToAction[href*='my-ign.80149/create-thread'] span").text.should == 'Post New Thread'
        end

      end
    end
  end
end
