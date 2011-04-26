require 'yaml'

class Browser
   attr_accessor :client

   #@@config_path = File.dirname(__FILE__) + "/selenium_firefox.yml"

   def self.config_path=(path)
     @@config_path = path
   end

   def initialize
     raise ConfigurationException, "Missing configuration file" unless File.exists?(@@config_path)
     options = YAML.load_file(@@config_path)
     @client = Selenium::Client::Driver.new \
         :host => options["hostname"],
         :port => options["port"],
         :browser => options["browser"],
         :url => options["baseurl"],
         :timeout_in_second => options["timeout"]

    @client.start_new_browser_session
    @client.window_focus
    @client.window_maximize
   end

   
   def shutdown
     @client.close_current_browser_session
   end
end

class ConfigurationException < StandardError; end;