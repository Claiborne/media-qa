require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'phantom_helpers/sign_in'; include SignIn

describe 'Boards - Search Functionality', :selenium => true do

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

    it "should display the search overlay when mouse-over 'Search Boards'" do
      @selenium.action.move_to(@selenium.find_element :link_text => 'Search Boards').perform
      @wait.until { @selenium.find_element(:css => 'input#QuickSearchQuery').displayed?}
    end

    it 'should type into the search overlay' do
      @selenium.find_element(:css => 'input#QuickSearchQuery').send_keys 'mass effect 3'
      @selenium.find_element(:css => 'input#search_bar_title_only').click
      sleep 1
    end

    it 'should submit the search and open the results page' do
      @selenium.find_element(:css => 'form.formPopup dl.submitUnit input.Tooltip').click
      @wait.until { @selenium.find_element(:css => 'h1').text == 'Search Results for Query: mass effect 3' }
    end

  end

  describe 'Search Results Page' do

    it "should return 50 results" do
      @selenium.find_elements(:css => "li.searchResult.thread.primaryContent h3.title").count.should == 50
    end

    it "should return results with only 'mass effect' and '3' in the title" do
      @selenium.find_elements(:css => "li.searchResult.thread.primaryContent h3.title").each do |t|
        t.text.downcase.match(/mass effect/).should be_true
        t.text.downcase.match(/3/).should be_true
      end
    end

    it 'should not contain any broken or 301 links to threads' do
      @selenium.find_elements(:css => "li.searchResult.thread.primaryContent h3.title a").each do |l|
        rest_client_not_301_open l.attribute('href').to_s
      end
    end

  end

end