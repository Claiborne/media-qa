#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "wallpost" do
wallpost_activity_id = ""
$wallpost = "posting wallpost from ruby script"
wallpost_type = "WALL_POST"
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
        "activityObjects"=>[{
                    "objectTitle"=>"posting wallpost from ruby script",
                    "type"=>"WALL_POST"}],
        "title"=>"posting wallpost from ruby script",
        "actorType"=>"PERSON",
        "verb"=>"POST",
        "actorId"=>"959653",
"targets"=>[{"type"=>"PERSON","objectId"=>"1938442"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/959653/@self?st=959653:959653:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
wallpost_activity_id= JSON.parse(response.body)["entry"]
puts $wallpost_activity_id
 end


  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.badgeTester/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for people @self for badgetester"
  end

it "should return valid response code for activities @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.badgeTester/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for activities @self for badgetester"
  end
  
it "should match the wallpost activityid with actorId @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.badgeTester/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityid with actorId @self"
  end

it "should match wall post activityid from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.mpanditign/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityId with target @self"
end


it "should match wall post type and activity object title from post with target" do
   response = RestClient.get "http://social-stg-services.ign.com/v1.0/social/rest/activities/nickname.mpanditign/@self"
   data = JSON.parse(response.body)
  $wallpost.should eql(data["entry"][0]["activityObjects"][0]["objectTitle"])
  wallpost_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
  puts "Matched wallpost type and activity object title with target @self"
end

it "should delete the wallpost  activityid" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.mpanditign/@self/#{wallpost_activity_id}?st=959653:959653:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
  puts "Deleted the wallpost activityId from actorId"
end

it "should check that wallpost is deleted from user" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.mpanditign/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from actor"
end

it "should check that the wallpost is deleted from target" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.badgeTester/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from target"
end
end
