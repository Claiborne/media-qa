
require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "people" do
wallpost_activity_id = ""
$wallpost_update = "testing wallpost from ruby"
  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

it "should post the wallpost" do
jdata = JSON.generate({"body"=>"test","appId"=>0,
"activityObjects"=>[
"objectTitle"=>"testing to check from ruby",
"type"=>"WALL_POST"],
"title"=>"testing to check from restclient",
"actorType"=>"PERSON",
"verb"=>"POST",
"actorId"=>"1557918",
"targets"=>[{"type"=>"PERSON","objectId"=>"1557870"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
wallpost_activity_id= JSON.parse(response.body)["entry"]
puts $wallpost_activity_id
 end

  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

it "should return valid response code for activities @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end
  
it "should match the wallpost activityid with posted user @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
   data = JSON.parse(response.body)
   $wallpost_activity_id.should eql(data["entry"][0]["id"])
  end

it "should match wall post activityid from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tulasiprod/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
end


it "should match wall post type and activity object title from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tulasiprod/@self"
   data = JSON.parse(response.body)
  #wallpost_update.should eql(data["entry"][0]["activityObjects"][0]["objectTitle")
end
end
