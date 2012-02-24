require 'yaml'

class Configuration
  attr_accessor :options
  attr_accessor :browser

  def self.config_path=(path)
    @@config_path = path
  end

  def initialize
    raise ConfigurationException, "Missing configuration file" unless File.exists?(@@config_path)
    environment = ENV['env']
    browser = ENV['browser']
    configs = YAML.load_file(@@config_path)
    @options = configs[environment]
    @browser = configs[browser]
  
    # this is a bad hack for branch substitution 
    @options['baseurl'].sub(/branchname/, ENV['branch']) unless ENV['branch'] == nil    
  end
end

class ConfigurationException < StandardError; end;
