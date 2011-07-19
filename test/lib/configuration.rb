require 'yaml'

class Configuration
  attr_accessor :options

  def self.config_path=(path)
    @@config_path = path
  end

  def initialize
    raise ConfigurationException, "Missing configuration file" unless File.exists?(@@config_path)
    environment = ENV['env'] 
    configs = YAML.load_file(@@config_path)
    @options = configs[environment]
  
    # this is a bad hack for branch substitution 
    @options['baseurl'].sub(/branchname/, ENV['branch']) unless ENV['branch'] == nil    
  end
end

class ConfigurationException < StandardError; end;
