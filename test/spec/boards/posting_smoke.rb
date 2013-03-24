require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
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

  context 'Sign In' do
    sign_in('/boards/')
  end

  describe "Main Page" do

    context 'Global Header and Nav' do
      check_global_header_nav
      check_header_signed_in
    end

    context 'Main Section' do
      check_main_section_list
    end

  end

end