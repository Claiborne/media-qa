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
    @options['baseurl'] = @options['baseurl'].gsub(/branchname/, ENV['branch']) unless ENV['branch'] == nil    
  end
end

class BrowserConfig
  attr_accessor :options

  def self.browser_path=(path)
    @@browser_path = path
  end

  def initialize
    raise ConfigurationException, "Missing configuration file" unless File.exists?(@@browser_path)
    browser = ENV['browser']
    configs = YAML.load_file(@@browser_path)
    @options = configs[browser]
  end
end

class DataConfiguration
  attr_accessor :options

  def self.config_path=(path)
    @@data_config_path = path
  end

  def initialize
    raise ConfigurationException, "Missing configuration file" unless File.exists?(@@data_config_path)
    services = ENV['services']
    configs = YAML.load_file(@@data_config_path)
    @options = configs[services]
  end
end

class ConfigurationException < StandardError; end;
