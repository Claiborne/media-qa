require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'open_page'; include OpenPage

describe 'Boards - Posting While Not Signed In', :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/boards.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
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

  describe "Main Page" do

    it "should open /boards" do
      @selenium.get "#@base_url/boards"
      @selenium.current_url.should == "#@base_url/boards/"
    end

    context 'Global Header and Nav' do
      check_global_header_nav
      check_header_signed_out
    end

    context 'Sidebar Log in Button' do
      check_sidebar_log_in
    end

    context 'Main Section' do
      check_main_section_list
      check_main_section_links
    end

  end

end
