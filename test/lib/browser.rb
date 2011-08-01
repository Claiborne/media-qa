require 'yaml'

class Browser
   attr_accessor :client

   @@config_path = "config/selenium.yml"

   def self.config_path=(path)
     @@config_path = path
   end

   def initialize
    puts "path: " + @@config_path
     raise ConfigurationException, "Missing configuration file" unless File.exists?(@@config_path)
     options = YAML.load_file(@@config_path)
     @client = Selenium::Client::Driver.new \
         :host => options["hostname"],
         :port => options["port"],
         :browser => options["browser"],
         :url => options["baseurl"],
         :timeout_in_second => options["timeout"]

    #@client.start_new_browser_session('commandLineFlags' => '--disable-web-security') #for *googlechrome
	@client.start_new_browser_session
    @client.window_maximize
   end
   
   def shutdown
     @client.close_current_browser_session
   end
end

class ConfigurationException < StandardError; end;
