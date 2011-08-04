require File.dirname(__FILE__) + "/../spec_helper"

describe "sub_api" do
  include WebService
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/prime/prime.yml"
    @config = Configuration.new
    
    @ads_are_not_disabled  = '{"AdsAreDisabled"=>false}'
    @ads_are_disabled      = '{"AdsAreDisabled"=>true}'
    
    @user_is_subscribed     = '{"HasFeature"=>true}'
    @user_is_not_subscribed = '{"HasFeature"=>false}'
    
    @ads_toggled_off  = '{"AdsAreDisabled"=>true}'
    @ads_toggled_on   = '{"AdsAreDisabled"=>false}'
  end

  before(:each) do

  end

  after(:each) do

  end
  
  it "should show ads are disabled" do
    disable_ads_for_user(@config.options['subscriber_id'])
    are_ads_disabled(@config.options['subscriber_id']).should eql @ads_are_disabled
  end  
  
  it "should show ads are NOT disabled" do
    enable_ads_for_user(@config.options['subscriber_id'])
    are_ads_disabled(@config.options['subscriber_id']).should eql @ads_are_not_disabled
  end
  
  it "should show user is a subscriber" do
    is_user_subscribed(@config.options['subscriber_id']).should eql @user_is_subscribed
  end  
  
  it "should show user is NOT a subscriber" do
    is_user_subscribed(@config.options['non_subscriber_id']).should eql @user_is_not_subscribed
  end
  
  it "should disable ads" do
    disable_ads_for_user(@config.options['subscriber_id']).should eql @ads_toggled_off
  end
  
  it "should enable ads" do
    enable_ads_for_user(@config.options['subscriber_id']).should eql @ads_toggled_on
  end
  
  it "should fail to disable ads" do
    disable_ads_for_user(@config.options['non_subscriber_id']).should eql @ads_toggled_on
  end
 end