require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "peoplefollow" do
people_activity_id = ""
follow_person_id = "10000"
verb = "FOLLOW"
actorType = "PERSON"

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

it "should follow the person" do
jdata = JSON.generate([{"id"=>"10000"}])
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/people/10001/@friends?st=10001:10001:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
people_activity_id= JSON.parse(response.body)["entry"]
puts $people_activity_id
 end

  it "should return valid people @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.Mopster_KD/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Verified it returns valid response code"
  end
  
  it "should return valid response code for people @friends" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/10001/@friends"
     response.code.should eql(200)
     data = JSON.parse(response.body)
     puts "Verified it returns valid response code for friends"
  end
  
  it "should match the personId the actor is following" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.Mopster_KD/@friends"
     data = JSON.parse(response.body)
     follow_person_id.should eql(data["entry"][0]["id"])
     puts "Verified that it matches the personId the actor is following"
  end 

it "should return valid response code for activities @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.Mopster_KD/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "Verified that it returns valid response code for activities"
  end
  
it "should match objectId, actorType and verb in activities" do
   sleep(5)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.Mopster_KD/@self"
   data = JSON.parse(response.body)
   follow_person_id.should eql(data["entry"][0]["activityObjects"][0]["objectId"])
   verb.should eql(data["entry"][0]["verb"])
   actorType.should eql(data["entry"][0]["actorType"])
   puts "Verified that the objectId actorType and verb in activities"
end

it "should unfollow the person" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/people/10001/@friends/#{follow_person_id}?st=10001:10001:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
end

it "should delete the person from people @friends list" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.Mopster_KD/@self"
  data = JSON.parse(response.body)
  follow_person_id.should_not eql(data["entry"][0]["id"])
end
end
