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
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym

    @wait = Selenium::WebDriver::Wait.new(:timeout => 7)

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

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
  
end