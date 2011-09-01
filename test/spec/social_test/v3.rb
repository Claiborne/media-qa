require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'


describe "V3" do

person_id = ""
people_activity_id = ""
follow_person_id = "10000"
verb = "FOLLOW"
actorType = "PERSON"
level = "New level achieved 2"
media_activity_id = ""
mediaItem_id = 65500
verb = "FOLLOW"
actorType = "PERSON"
wishList = true
released = true
unreleased = false
rating = "6"
gamercard_activity_id = ""
accounts_id = "WII_ID"
gamerCard_type = "GAMER_CARD"
 
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new

    @nickname = "socialnick1_#{Random.rand(200-9999)}"
    @joined = "#{@nickname} joined the community"
  end

  before(:each) do
    
  end

  after(:each) do
  end
  it "should register a new user" do
@time_stamp = Time.now.to_s 
@email = "socialuser1_#{Random.rand(100-9999)}@ign.com"
@key1 = "102353435#{Random.rand(10-1000)}"
jdata = JSON.generate({"email"=>"#{@email}","nickname"=>"#{@nickname}","accounts"=>[{"accountType"=>"fedreg","key1"=>"#{@key1}","key2"=>""}]})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/reg",jdata, {:content_type => 'application/json'}
person_id= JSON.parse(response.body)["entry"]
#puts 'response complete'
puts person_id
puts @nickname
end

it "should get valid response for the new user with people/@self" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
  response.code.should eql(200)
  data = JSON.parse(response.body)
end

it "should get valid response for the new user with activities/@self" do
response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
response.code.should eql(200)
   data = JSON.parse(response.body)
end

it "should match the personId from new registration" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
  data = JSON.parse(response.body)
  person_id[0].to_s().should eql(data["entry"][0]["id"].to_s())
end

it "should match the new level acheived" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
  data = JSON.parse(response.body)
  level.should eql(data["entry"][0]["body"])
  @joined.should eql(data["entry"][1]["body"])
end

 it "should follow one gamercard" do
  jdata = JSON.generate({"accounts"=>[{"id"=>1,"accountType"=>"wii_id","key1"=>"test","key2"=>"","isGamerCard"=>"true"}]})
  puts jdata
  response = RestClient.put "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id[0].to_s}/@self?st=#{person_id[0].to_s}:#{person_id[0].to_s}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
  data = JSON.parse(response.body)
end

it "should return valid response code for activities after the gamercard is added" do
         response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id[0].to_s}/@self"
         response.code.should eql(200)
         data = JSON.parse(response.body)
  end
  
it " should valid the gamercard entry in people@self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id[0].to_s}/@self"
  data = JSON.parse(response.body)
  accounts_id.should eql(data["entry"][0]["accounts"][1]["accountType"])
end

it " should valid the gamercard entry in activities@self" do
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id[0].to_s}/@self"
  data = JSON.parse(response.body)
  accounts_id.should eql(data["entry"][1]["activityObjects"][0]["objectTitle"])
  gamerCard_type.should eql(data["entry"][1]["activityObjects"][0]["type"])
end
end