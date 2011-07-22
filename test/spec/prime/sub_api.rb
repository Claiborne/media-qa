require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "sub_api" do
  before(:all) do
    $AdsAreNotDisabled  = '{"AdsAreDisabled"=>false}'
    $AdsAreDisabled     = '{"AdsAreDisabled"=>true}'
    
    

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/prime.yml"
    @config = Configuration.new
  end

  after(:each) do

  end
  
  it "should show ads are NOT disabled" do
    user_id = "172912790";
    jdata = JSON.generate(["status" => "Status"]);
    response = RestClient.get "http://subscriptionservices.ign.com/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/JSON/#{user_id}", {:content_type => 'application/json'}
    json_response = JSON.parse(response.body).to_s
    json_response.should eql $AdsAreNotDisabled
  end
end