require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "FriendsOnly" do
friendsFlag = "true"
wallpost_activity_id = ""
$wallpost_update = "posting wallpost only on friends wall"
wallpost_type = "WALL_POST"
flag = "false"

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
  end

  after(:each) do

  end
  
it "should set the allowfriendsonly flag to true" do
  jdata = JSON.generate({"allowOnlyFriendsToPostOnMyWall"=>"true"})
  response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/usersettings/1723480/@self?st=1723480:1723480:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
end

it "should return valid people @self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/1723480/@self"
  response.code.should eql(200)
  data = JSON.parse(response.body)
  puts "Got Valid response code for people @self for aggregationtester01"
end

it "should check the flag to true people/@self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/1723480/@self"
  data = JSON.parse(response.body)
  friendsFlag.should eql(data["entry"][0]["settings"]["allowOnlyFriendsToPostOnMyWall"])
end

it "should post the wallpost" do
jdata = JSON.generate({"body"=>"test","appId"=>0,
"activityObjects"=>[
"objectTitle"=>"posting wallpost only on friends wall",
"type"=>"WALL_POST"],
"title"=>"posting wallpost only on friends wall",
"actorType"=>"PERSON",
"verb"=>"POST",
"actorId"=>"1778593",
"targets"=>[{"type"=>"PERSON","objectId"=>"1723480"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778593/@self?st=1778593:1778593:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
wallpost_activity_id= JSON.parse(response.body)["entry"]
puts $wallpost_activity_id
 end

  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.aggregationtester01/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for people @self for aggregationtester01"
  end

it "should return valid response code for activities @self" do
  sleep(5)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for activities @self for aggregationtester02"
  end
  
it "should match the wallpost activityid with actorId @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityid with actorId @self"
  end

it "should match wall post activityid from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityId with target @self"
end


it "should match wall post type and activity object title from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
   data = JSON.parse(response.body)
  $wallpost_update.should eql(data["entry"][0]["activityObjects"][0]["objectTitle"])
  wallpost_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
  puts "Matched wallpost type and activity object title with target @self"
end

it "should delete the wallpost  activityid" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778593/@self/#{wallpost_activity_id}?st=1778593:1778593:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
  puts "Deleted the wallpost activityId from actorId"
end

it "should check that wallpost is deleted from user" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from actor"
end

it "should check that the wallpost is deleted from target" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from target"
end

it "should not allow non-friends to post on the wall" do
  jdata = JSON.generate({"body"=>"test","appId"=>0,
"activityObjects"=>[
"objectTitle"=>"posting wallpost only on friends wall",
"type"=>"WALL_POST"],
"title"=>"posting wallpost only on friends wall",
"actorType"=>"PERSON",
"verb"=>"POST",
"actorId"=>"1778592",
"targets"=>[{"type"=>"PERSON","objectId"=>"1723480"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self?st=1778592:1778592:0:ign.com:my.ign.com:0:0", jdata, {:content_type => 'application/json'}
#puts response.code
puts '------------'
#puts response.headers["Status"]

#puts response.body
#response.body.should include ("forbidden")
end

it "should set the allowfriendsonly flag to false" do
  jdata = JSON.generate({"allowOnlyFriendsToPostOnMyWall"=>"false"})
  response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/usersettings/1723480/@self?st=1723480:1723480:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
end

it "should return valid people @self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/1723480/@self"
  response.code.should eql(200)
  data = JSON.parse(response.body)
  puts "Got Valid response code for people @self for aggregationtester01"
end

it "should check the flag to false people/@self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/1723480/@self"
  data = JSON.parse(response.body)
  flag.should eql(data["entry"][0]["settings"]["allowOnlyFriendsToPostOnMyWall"])
end

it "should post the wallpost" do
jdata = JSON.generate({"body"=>"test","appId"=>0,
"activityObjects"=>[
"objectTitle"=>"posting wallpost only on friends wall",
"type"=>"WALL_POST"],
"title"=>"posting wallpost only on friends wall",
"actorType"=>"PERSON",
"verb"=>"POST",
"actorId"=>"1778593",
"targets"=>[{"type"=>"PERSON","objectId"=>"1723480"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778593/@self?st=1778593:1778593:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
wallpost_activity_id= JSON.parse(response.body)["entry"]
puts $wallpost_activity_id
 end

  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.aggregationtester01/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for people @self for aggregationtester01"
  end

it "should return valid response code for activities @self" do
  sleep(5)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for activities @self for aggregationtester02"
  end
  
it "should match the wallpost activityid with actorId @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityid with actorId @self"
  end

it "should match wall post activityid from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityId with target @self"
end


it "should match wall post type and activity object title from post with target" do
  sleep(8)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
   data = JSON.parse(response.body)
  $wallpost_update.should eql(data["entry"][0]["activityObjects"][0]["objectTitle"])
  wallpost_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
  puts "Matched wallpost type and activity object title with target @self"
end

it "should delete the wallpost  activityid" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778593/@self/#{wallpost_activity_id}?st=1778593:1778593:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
  puts "Deleted the wallpost activityId from actorId"
end

it "should check that wallpost is deleted from user" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester02/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from actor"
end

it "should check that the wallpost is deleted from target" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
  data = JSON.parse(response.body)
  wallpost_activity_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the wallpost is deleted from target"
end

it "should allow non-friends to post on the wall" do
  jdata = JSON.generate({"body"=>"test","appId"=>0,
"activityObjects"=>[
"objectTitle"=>"posting wallpost only on friends wall",
"type"=>"WALL_POST"],
"title"=>"posting wallpost only on friends wall",
"actorType"=>"PERSON",
"verb"=>"POST",
"actorId"=>"1778592",
"targets"=>[{"type"=>"PERSON","objectId"=>"1723480"}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self?st=1778592:1778592:0:ign.com:my.ign.com:0:0", jdata, {:content_type => 'application/json'}
wallpost_activity_id= JSON.parse(response.body)["entry"]
puts $wallpost_activity_id
end

it "should return valid response code for activities @self" do
  sleep(5)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester03/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Got valid response code for activities @self for aggregationtester02"
  end
  
it "should match the wallpost activityid with actorId @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester03/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityid with actorId @self"
  end

it "should match wall post activityid from post with target" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester01/@self"
   data = JSON.parse(response.body)
   wallpost_activity_id.should eql(data["entry"][0]["id"])
   puts "Matched the wallpost activityId with target @self"
end

it "should delete the wallpost  activityid" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self/#{wallpost_activity_id}?st=1778592:1778592:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
  puts "Deleted the wallpost activityId from actorId"
end

it "should check that wallpost is deleted from user" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregationtester03/@self"
  data = JSON.parse(response.body)
 0.should eql (data["totalResults"])
  puts "Verified that the wallpost is deleted from actor"
end
end