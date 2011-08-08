require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'
require 'oauth'

describe "people" do
status_activity_id = ""
$status_update = "testing status with script1"
  before(:all) do

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
jdata = JSON.generate(["status" => "Status"]);
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/status/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",{"status" => $status_update}.to_json, {:content_type => 'application/json'}
status_activity_id= JSON.parse(response.body)["entry"]
puts $status_activity_id
 end

  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "returns valid response code for people @self"
  end

  it "should match the status with the @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
   data = JSON.parse(response.body)
   $status_update.should eql(data["entry"][0]["status"])
   puts "Verified that it match the status update" 
  end


  it "should return valid response code for activities @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "verified it match the responsecode for activities"
  end


it "should match status activityid from post" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   data = JSON.parse(response.body)
   status_activity_id.should eql(data["entry"][0]["id"])
   puts "Verified that it matches the status activityid"
end

it "should delete the status activityid" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self/#{status_activity_id}?st=1557918:1557918:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
   puts "Deleted the status activityid" 
end

it "should check that status is deleted" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
  data = JSON.parse(response.body)
  status_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the status is deleted"
end
end

