require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "sub_api" do
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/prime/subapi.yml"
    @config = Configuration.new
    
    @ads_are_not_disabled  = '{"AdsAreDisabled"=>false}'
    @ads_are_disabled      = '{"AdsAreDisabled"=>true}'
    
    @user_is_subscriber     = '{"HasFeature"=>true}'
    @user_is_not_subscriber = '{"HasFeature"=>false}'
    
    @ads_toggled_off  = '{"AdsAreDisabled"=>true}'
    @ads_toggled_on   = '{"AdsAreDisabled"=>false}'
    
    @subscriber_featureID = '10014'
  end

  before(:each) do

  end

  after(:each) do

  end
  
  it "should show ads are disabled" do
    RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{@config.options['subscriber_id']}/true"
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/JSON/#{@config.options['subscriber_id']}", {:content_type => 'application/json'}
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @ads_are_disabled
  end  
  
  it "should show ads are NOT disabled" do
    RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{@config.options['subscriber_id']}/false"
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/JSON/#{@config.options['subscriber_id']}", {:content_type => 'application/json'}
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @ads_are_not_disabled
  end
  
  it "should show user is a subscriber" do
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/UserHasFeature/JSON/#{@config.options['subscriber_id']}/#{@subscriber_featureID}", {:content_type => 'application/json'}
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @user_is_subscriber
  end  
  
  it "should show user is NOT a subscriber" do
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/UserHasFeature/JSON/#{@config.options['non_subscriber_id']}/#{@subscriber_featureID}", {:content_type => 'application/json'}
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @user_is_not_subscriber
  end
  
  it "should disable ads" do
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{@config.options['subscriber_id']}/true"
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @ads_toggled_off
  end
  
  it "should enable ads" do
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{@config.options['subscriber_id']}/false"
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @ads_toggled_on
  end
  
  it "should fail to disable ads" do
    response = RestClient.get "http://#{@config.options['baseurl']}/1.0/FeatureCheckService.svc/web/ToggleAdsForUser/JSON/#{@config.options['non_subscriber_id']}/true"
    json_response = JSON.parse(response.body).to_s
    json_response.should eql @ads_toggled_on
  end
end