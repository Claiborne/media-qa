require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'open_page'
require 'json'
require 'open_page'; include OpenPage
require 'widget-plus/global_header_nav.rb'; include GlobalHeaderNav
require 'widget-plus/global_footer.rb'; include GlobalFooter

%w(www uk au).each do |locale|
['halo 4', 'game of thrones'].each do |query|
describe "Search Page -- #{locale}", :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/phantom.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @page = "http://#{@config.options['baseurl']}/search?q=#{query}".gsub('//www',"//#{locale}")
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 3)

    case locale
      when 'uk'
        @selenium.get "http://uk.ign.com/?setccpref=UK"
      when 'au'
        @selenium.get "http://au.ign.com/?setccpref=AU"
      else
    end

    # Search using global header
    @selenium.get "http://#{@config.options['baseurl']}"
    search_box = @selenium.find_element :css => 'input#ignHeader-search'
    search_box.send_keys(query)
    search_box.submit

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open the search page in #{ENV['env']}" do
    @selenium.get @page
    sleep 3
    @selenium.current_url.gsub('%20',' ').should == @page
  end

  context "Search Header" do

    it "should be displayed" do
      @selenium.find_element :css => "div[class='search-header ']"
    end

    it "should display the input box" do
      @selenium.find_element(:css => "div[class='search-header '] input#query-input").displayed?.should be_true
    end

    it "should display the query in the input box" do
      @selenium.find_element(:css => "div[class='search-header '] input#query-input").attribute('value').should == query
    end

  end

  context "Search Menu Bar" do

    it "should be displayed" do
      @selenium.find_element(:css => "div.search-menu-bar div.menu-bar").displayed?.should be_true
    end

    it "should display the correct text" do
      expected_nav = %w(everything games tv/movies videos articles wikis)
      nav = []

      @selenium.find_elements(:css => "div.search-menu-bar div.menu-bar div.menu-item").each do |li|
        nav << li.text.downcase
      end

      nav.should == expected_nav
    end

  end

  context "Search Results" do

    it "should be displayed" do
      @selenium.find_element(:css => 'div#search-list').displayed?.should be_true
    end

    it "should return 10 results" do
      @selenium.find_elements(:css => 'div#search-list div.search-item').count.should == 10
    end

    it "should return and display 10 titles" do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').count.should == 10
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').each do |title|
        title.displayed?.should be_true
        title.text.delete('^a-zA-Z').length.should > 0
      end
    end

    it "should link to an IGN page when the title is clicked" do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').count.should == 10
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |title|
        title.attribute('href').to_s.match(/ign\.com\/[a-z]/).should be_true
      end
    end

    it "should open a page when the title is clicked", :spam => true do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |title|
        rest_client_not_301_home_open title.attribute('href').to_s
      end
    end

  end

  context "Global Header and Nav Widget" do
    check_global_header_nav
  end

  context "Global Footer Widget" do
    check_global_footer
  end

end end end