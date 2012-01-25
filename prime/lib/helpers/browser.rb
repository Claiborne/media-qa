require 'yaml'
require "rubygems"
require "selenium-webdriver"

class Browser
   attr_accessor :client

   #@@config_path = File.dirname(__FILE__) + "/selenium_firefox.yml"

   def self.type=(browser)
   	puts "browser self is #{browser}"
    @@browser_type = browser
   end

   def initialize
   	puts "browser is #{@@browser_type}"
   	case @@browser_type
   	when "Chrome"
   		@client = Selenium::WebDriver.for :chrome
   	when "Firefox"
   		@client = Selenium::WebDriver.for :firefox
   	when "IE"
   		@client = Selenium::WebDriver.for :ie
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