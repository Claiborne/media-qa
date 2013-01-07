#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'pathconfig'
require 'rubygems'
require 'rubygems'
require 'oauth'

describe "status_oauth" do
status_activity_id = ""
status = "testing status with oauth"
id ="1557918"
@access_token
  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = PathConfig.new
    IGNSOCIAL_OAUTH_CONSUMER_KEY ="ign.com"
      IGNSOCIAL_OAUTH_SECRET = "ba+e0bkSJJc5tu17LTtftlaUEv5VMX0F1Wzj7jjZ5N0="
      #do the 2 legged oauth here
      consumer = OAuth::Consumer.new(IGNSOCIAL_OAUTH_CONSUMER_KEY, IGNSOCIAL_OAUTH_SECRET,:site => "social-services.ign.com/v1.0")
      @access_token = OAuth::AccessToken.new consumer
 end

  after(:each) do

  end


it "should post the status update" do
#user_id = "1557918";
#status = "Status";
#jdata = JSON.generate(["id" => "14332801"]);
@access_token.post("http://social-services.ign.com/v1.0/social/rest/mediaItems/#{id}/@self?xoauth_requestor_id=#{id}", [{"id"=>"gobid.14332801"}], {'Content-Type'=>'application/json; charset=UTF-8'})
#status_activity_id= JSON.parse(response.body)["entry"]
#puts $status_activity_id
 end
end

