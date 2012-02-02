require 'yaml'
require "rubygems"
require "selenium-webdriver"

class Browser
   attr_accessor :client

   #@@config_path = File.dirname(__FILE__) + "/selenium_firefox.yml"

   def self.type=(browser)
    @@browser_type = browser
   end

   def initialize
   	case @@browser_type
   	when "Chrome"
   		@client = Selenium::WebDriver.for :chrome
   	when "Firefox"
   		@client = Selenium::WebDriver.for :firefox
   	when "IE"
   		@client = Selenium::WebDriver.for :ie
   	when "Headless"
   		caps = Selenium::WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => true)
   		@client = Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => caps
   	end
   	@client.manage.timeouts.implicit_wait = 10
     # raise ConfigurationException, "Missing configuration file" unless File.exists?(@@config_path)
     # options = YAML.load_file(@@config_path)
     # @client = Selenium::Client::Driver.new \
         # :host => options["hostname"],
         # :port => options["port"],
         # :browser => options["browser"],
         # :url => options["baseurl"],
         # :timeout_in_second => options["timeout"]
# 
    # @client.start_new_browser_session
    # @client.window_focus
    # @client.window_maximize
    @@browser = nil
   end

   def shutdown
     @client.quit
   end
end

class ConfigurationException < StandardError; end;