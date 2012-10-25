require 'rspec'
require 'selenium-webdriver'
require 'configuration'
require 'rest-client'
require 'open_page'

include OpenPage

######################################################################

describe "Images Gallery Page -- /videos/2012/10/19/news-mass-effect-4-wont-star-shepard-2", :selenium => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/phantom.yml"
    @config = Configuration.new

    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @path = "/videos/2012/10/19/news-mass-effect-4-wont-star-shepard-2"
    @page = "http://#{@config.options['baseurl']}#{@path}"
    puts @path+" using "+@browser_config.options['browser']
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open the Far Cry 3 gallery page", :smoke => true do
    @selenium.get @page
    # Do I need to wait for load?
    @selenium.current_url.match(Regexp.new(@path)).should be_true
  end

end
