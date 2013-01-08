#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'
require 'topaz_token'

include TopazToken



describe "core features" do

  person_id = ""
  people_activity_id = ""
  follow_person_id = "1557918"
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
  accounts_id = "WII_ID"
  gamerCard_type = "GAMER_CARD"
  topaz_id = 0
  testEmail =""


  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
    @id = "#{Random.rand(60000000-900000000)}"
    @nickname = "socialtest2_#{Random.rand(200-99999)}"
    @joined = "#{@nickname} joined the community"
    TopazToken.set_token('social')

  end

  before(:each) do

  end

  after(:each) do
  end

 it "should register a new user" do
    @time_stamp = Time.now.to_s
    testEmail = "topaztulasi5_#{Random.rand(100-99999)}@ign.com"
    @key1 = "102353737#{Random.rand(10-1000)}"
    jdata = JSON.generate({"email"=> testEmail,"nickname"=>"#{@nickname}","accounts"=>[{"id"=> @id.to_i, "accountType"=>"topaz","key1"=> "#{@key1}","key2"=>"local"}]})
    puts jdata
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/reg",jdata, {:content_type => 'application/json'}
    puts response.body
    person_id= JSON.parse(response.body)["entry"][0]
 end

  it "should register in Topaz to get topaz Id", :test => true do
    @profileId = "#{Random.rand(3000-40000000)}"
    testEmail = "topaztulasi5_#{Random.rand(100-9999)}@ign.com"
    jdata = JSON.generate({"profileId" => person_id, "email" => testEmail, "provider" => "local", "password" => "test234"})
    puts jdata
    response = RestClient.post "http://secure-stg.ign.com/v3/authentication/user/register?oauth_token=#{TopazToken.return_token}", jdata, {:content_type => 'application/json'}
    puts response.body
    topaz_id = JSON.parse(response.body)["data"][0]["userId"]
    puts topaz_id

  end

  it "should update the social service with the real topazID" do
    jdata = JSON.generate({"accounts"=>[{"id" => @id.to_i,"accountType"=>"topaz","key1"=> topaz_id,"key2"=>"local"}]})
    response = RestClient.put "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id}", jdata, {:content_type => 'application/json'}
    puts response.body
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
    person_id.to_s().should eql(data["entry"][0]["id"].to_s())
  end

  it "should match the new level acheived" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    @joined.should eql(data["entry"][1]["body"])
    #level.should eql(data["entry"][0]["body"])
  end

  it "should follow the person" do
    jdata = JSON.generate([{"id"=>"1557918"}])
    puts jdata
    puts person_id.to_s()
    puts "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id.to_s}/@friends?st=#{person_id.to_s}:#{person_id.to_s}:0:ign.com:my.ign.com:0:0"
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id.to_s}/@friends?st=#{person_id.to_s}:#{person_id.to_s}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    puts response.body
    data = JSON.parse(response.body)["entry"]
    puts data

  end

  it "should return valid people @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Verified it returns valid response code"
  end

  it "should return valid response code for people @friends" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@friends"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Verified it returns valid response code for friends"
  end

  it "should match the personId the actor is following" do
    sleep(5)
    puts "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@friends"
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@friends"
    data = JSON.parse(response.body)
    1557918.to_s().should eql(data["entry"][0]["id"])
    puts "Verified that it matches the personId the actor is following"
  end

  it "should return valid response code for activities @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Verified that it returns valid response code for activities"
  end

  it "should match objectId, actorType and verb in activities" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    1557918.to_s().should eql(data["entry"][0]["activityObjects"][0]["objectId"])
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
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    follow_person_id.should_not eql(data["entry"][0]["id"])
  end

  it "should post the wallpost" do

    jdata = JSON.generate({"body"=>"test","appId"=>0,
                           "activityObjects"=>[{
                               "objectTitle"=>"posting wallpost only on friends wall",
                               "type"=>"WALL_POST"}],
                           "title"=>"posting wallpost only on friends wall",
                           "actorType"=>"PERSON",
                           "verb"=>"POST",
                           "actorId"=>"1778593",
                           "targets"=>[{"type"=>"PERSON","objectId"=>"1723480"}]})
    puts jdata
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778593/@self?st=1778593:1778593:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    wallpost_activity_id= JSON.parse(response.body)["entry"]
    puts $wallpost_activity_id
  end
end
