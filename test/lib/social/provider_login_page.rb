# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'page'

class ProviderLoginPage < Page
  attr_accessor :provider_config

  def initialize(client,config,provider_name)
    super(client,config)
    provider_config_file = File.dirname(__FILE__) + "/../../config/oyster/provider_login_config.yml"
    configs = YAML.load_file(provider_config_file)
    @provider_config = configs[provider_name]
  end

  def login(user, password)
     @client.type @provider_config['username'], user
     @client.type @provider_config['password'], password
     @client.click @provider_config['button']
     @client.wait_for_page_to_load
  end

  def approve_request_allowed
    @client.click @provider_config['approval_allow_button']
    @client.wait_for_page_to_load
  end

  def approve_request_denied
    @client.click @provider_config['approval_deny_button']
    @client.wait_for_page_to_load
  end
end
