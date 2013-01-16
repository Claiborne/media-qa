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
describe "Search Page -- #{locale}", :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/phantom.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @page = "http://#{@config.options['baseurl']}/search".gsub('//www',"//#{locale}")
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 60)

    case locale
      when 'uk'
        @selenium.get "http://uk.ign.com/?setccpref=UK"
      when 'au'
        @selenium.get "http://uk.ign.com/?setccpref=AU"
      else
    end

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
    @selenium.current_url.should == @page
  end

  context "Global Header and Nav Widget" do
    check_global_header_nav
  end

  context "Global Footer Widget" do
    check_global_footer
  end

end end