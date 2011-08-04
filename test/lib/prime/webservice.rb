require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

module WebService
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/prime/prime.yml"
    @config = Configuration.new
    
    def disable_ads_for_user(user_id)
      response = RestClient.get "http://#{@config.options['api_baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{user_id}/true", {:content_type => 'application/json'}
      return JSON.parse(response.body).to_s
    end
    
    def enable_ads_for_user(user_id)
      response = RestClient.get "http://#{@config.options['api_baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{user_id}/false", {:content_type => 'application/json'}
      return JSON.parse(response.body).to_s
    end

    def are_ads_disabled(user_id)
      response = RestClient.get "http://#{@config.options['api_baseurl']}/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/JSON/#{user_id}", {:content_type => 'application/json'}
      return JSON.parse(response.body).to_s
    end
    
    def is_user_subscribed(user_id)
      response = RestClient.get "http://#{@config.options['api_baseurl']}/1.0/FeatureCheckService.svc/web/UserHasFeature/JSON/#{user_id}/#{@config.options['subscriber_feature_id']}", {:content_type => 'application/json'}
      return JSON.parse(response.body).to_s
    end
end