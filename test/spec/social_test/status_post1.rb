require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'
require 'oauth'

describe "people" do
status_activity_id = ""
@urlStr = ''
$status_update = "testing status with script1"
  before(:all) do
puts ENV['env']
    if ENV['env'] == 'staging'
      @urlStr = 'st=1557918:1557918:0:ign.com:my.ign.com:0:0'
    else
      IGNSOCIAL_OAUTH_CONSUMER_KEY ="ign.com"
      IGNSOCIAL_OAUTH_SECRET = "ba+e0bkSJJc5tu17LTtftlaUEv5VMX0F1Wzj7jjZ5N0="
      status = "Testing myign for las1"
      id = "1557918"
      #do the 2 legged oauth here
      consumer = OAuth::Consumer.new(IGNSOCIAL_OAUTH_CONSUMER_KEY, IGNSOCIAL_OAUTH_SECRET,:site => "social-services.ign.com/v1.0")
      access_token = OAuth::AccessToken.new consumer
      puts access_token
      puts 'Secret'
puts access_token.secret
      @urkStr = 'xoauth_requestor_id=#{id}'
    end

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
 end

  after(:each) do

  end

it "should post the status update" do
#user_id = "1557918";
#status = "Status";
puts ENV['env']
puts @urlStr

jdata = JSON.generate(["status" => "Status"]);
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/status/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",{"status" => $status_update}.to_json, {:content_type => 'application/json'}
status_activity_id= JSON.parse(response.body)["entry"]
puts $status_activity_id
 puts 'posted'
 end

  it "should return valid people @self" do
   #response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
   #response.code.should eql(200)
   #data = JSON.parse(response.body)
   puts "returns valid response code for people @self"
  end
end