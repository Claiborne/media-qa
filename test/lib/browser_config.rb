require 'yaml'

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

class ConfigurationException < StandardError; end;