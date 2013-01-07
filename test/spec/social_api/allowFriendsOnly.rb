require 'rspec'
require 'rest_client'
require 'json'
require 'pathconfig'
require 'rubygems'
require 'topaz_token'


include TopazToken

describe "FriendsOnly" do
  friendsFlag = "true"
  wallpost_activity_id = ""
  wallpost_activity_id1 =""
  wallpost_activity_id2 =""
  $wallpost_update = "posting wallpost only on friends wall"
  wallpost_type = "WALL_POST"
  flag = "false"
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
  topaz_id = 0
  testEmail =""
  nickname = ""


  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = PathConfig.new
    @id = "#{Random.rand(60000000-900000000)}"
    @nickname = "socialtestt3_#{Random.rand(200-9999)}"
    @joined = "#{@nickname} joined the community"
    TopazToken.set_token('social')

  end

  after(:each) do

  end

  it "should register a new user" do
    @time_stamp = Time.now.to_s
    testEmail = "topaztulasi6_#{Random.rand(100-9999)}@ign.com"
    @key1 = "102353737#{Random.rand(10-1000)}"
    jdata = JSON.generate({"email"=> testEmail,"nickname"=>"#{@nickname}","accounts"=>[{"id"=> @id.to_i, "accountType"=>"topaz","key1"=> "#{@key1}","key2"=>"local"}]})
    puts jdata
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/reg",jdata, {:content_type => 'application/json'}
    puts response.body
    person_id = JSON.parse(response.body)["entry"][0]
  end

  it "should register in Topaz to get topaz Id", :test => true do
    @profileId = "#{Random.rand(3000-40000000)}"
    #testEmail = "topaztulasi5_#{Random.rand(100-9999)}@ign.com"
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

  it "should set the allowfriendsonly flag to true" do
    jdata = JSON.generate({"allowOnlyFriendsToPostOnMyWall"=>"true"})
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/usersettings/#{person_id}/@self?st=#{person_id}:#{person_id}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    puts response
  end

  it "should return valid people @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id}/@self"
    puts response
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got Valid response code for people @self for #{nickname}"
  end

  it "should check the flag to true people/@self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id}/@self"
    data = JSON.parse(response.body)
    puts
    friendsFlag.should eql(data["entry"][0]["settings"]["allowOnlyFriendsToPostOnMyWall"])
  end

  it "should post the wallpost" do
    jdata = JSON.generate({"body"=>"test","appId"=>0,
                           "activityObjects"=>[{
                                                   "objectTitle"=>"posting wallpost only on friends wall",
                                                   "type"=>"WALL_POST"}],
                           "title"=>"posting wallpost only on friends wall",
                           "actorType"=>"PERSON",
                           "verb"=>"POST",
                           "actorId"=>"#{person_id}",
                           "targets"=>[{"type"=>"PERSON","objectId"=>"1557918"}]})
    puts jdata
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id}/@self?st=#{person_id}:#{person_id}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    wallpost_activity_id= JSON.parse(response.body)["entry"]
    puts wallpost_activity_id
  end

  it "should return valid people @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.tchandrada/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got valid response code for people @self for tchandrada"
  end

  it "should return valid response code for activities @self" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got valid response code for activities @self for tchandrada"
  end

  it "should match the wallpost activityid with actorId @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{nickname}/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should eql(data["entry"][0]["id"])
    puts wallpost_activity_id
    puts "Matched the wallpost activityid with actorId @self"
  end

  it "should match wall post activityid from post with target" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should eql(data["entry"][0]["id"])
    puts "Matched the wallpost activityId with target @self"
  end


  it "should match wall post type and activity object title from post with target" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
    data = JSON.parse(response.body)
    $wallpost_update.should eql(data["entry"][0]["activityObjects"][0]["objectTitle"])
    wallpost_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
    puts "Matched wallpost type and activity object title with target @self"
  end

  #A is a new user who we create in the begining
  it "should delete the wallpost  activityid from actor(A)" do
    response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id}/@self/#{wallpost_activity_id}?st=#{person_id}:#{person_id}:0:ign.com:my.ign.com:0:0"
    puts response
    data = JSON.parse(response.body)
    puts data
    puts "Deleted the wallpost activityId from actorId"
  end

  #Make sure that the activity is been deleted
  it "should check that wallpost is deleted from user(A)" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{nickname}/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should_not eql(data["entry"][0]["id"])
    puts "Verified that the wallpost is deleted from actor"
  end

  #B is the tchandrada user, where we are making sure that the activity is been deleted when A deletes.
  it "should check that the wallpost is deleted from target(B)" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should_not eql(data["entry"][0]["id"])
    puts "Verified that the wallpost is deleted from target"
  end

  #Pick a non-friend (C) for A where he shouldn't able to post on his wall
  it "should not allow non-friends to post on the wall" do
    jdata = JSON.generate({"body"=>"test","appId"=>0,
                           "activityObjects"=>[{
                                                   "objectTitle"=>"posting wallpost only on friends wall",
                                                   "type"=>"WALL_POST"}],
                           "title"=>"posting wallpost only on friends wall",
                           "actorType"=>"PERSON",
                           "verb"=>"POST",
                           "actorId"=>"1778592",
                           "targets"=>[{"type"=>"PERSON","objectId"=>"#{person_id}"}]})
    response = RestClient.post("http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self?st=1778592:1778592:0:ign.com:my.ign.com:0:0", jdata, {:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(403)
      puts '403 cannot post to the wall'

    }

  end

  #Now set the allowfriends only flag to false for A user.
  it "should set the allowfriendsonly flag to false" do
    jdata = JSON.generate({"allowOnlyFriendsToPostOnMyWall"=>"false"})
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/usersettings/#{person_id}/@self?st=#{person_id}:#{person_id}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
  end

  #Verify that user A get the people service
  it "should return valid people @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got Valid response code for people @self for #{nickname}"
  end

  #Verify that the user A allowfriendsonly flag is false
  it "should check the flag to false people/@self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id}/@self"
    data = JSON.parse(response.body)
    flag.should eql(data["entry"][0]["settings"]["allowOnlyFriendsToPostOnMyWall"])
  end

  #Post the wall post with user B to User A.
  it "should post the wallpost" do
    jdata = JSON.generate({"body"=>"test","appId"=>0,
                           "activityObjects"=>[{
                                                   "objectTitle"=>"posting wallpost only on friends wall",
                                                   "type"=>"WALL_POST"}],
                           "title"=>"posting wallpost only on friends wall",
                           "actorType"=>"PERSON",
                           "verb"=>"POST",
                           "actorId"=>"1557918",
                           "targets"=>[{"type"=>"PERSON","objectId"=>"#{person_id}"}]})
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    wallpost_activity_id= JSON.parse(response.body)["entry"]
    puts wallpost_activity_id
  end

  it "should return valid people @self" do
    puts "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{nickname}/@self"
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{nickname}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got valid response code for people @self for #{nickname}"
  end

  it "should return valid response code for activities @self" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got valid response code for activities @self for tchandrada"
  end

  it "should match the wallpost activityid with actorId @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should eql(data["entry"][0]["id"])
    puts "Matched the wallpost activityid with actorId @self"
  end

  it "should match wall post activityid from post with target" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{nickname}/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should eql(data["entry"][0]["id"])
    puts "Matched the wallpost activityId with target @self"
  end


  it "should match wall post type and activity object title from post with target" do
    sleep(8)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id}/@self"
    data = JSON.parse(response.body)
    $wallpost_update.should eql(data["entry"][0]["activityObjects"][0]["objectTitle"])
    wallpost_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
    puts "Matched wallpost type and activity object title with target @self"
  end

  it "should delete the wallpost  activityid" do
    response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self/#{wallpost_activity_id}?st=1557918:1557918:0:ign.com:my.ign.com:0:0"
    data = JSON.parse(response.body)
    puts response.body
    puts "Deleted the wallpost activityId from actorId"
  end

  it "should check that wallpost is deleted from user" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should_not eql(data["entry"][0]["id"])
    puts "Verified that the wallpost is deleted from actor"
  end

  it "should check that the wallpost is deleted from target" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{nickname}/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id1.should_not eql(data["entry"][0]["id"])
    puts "Verified that the wallpost is deleted from target"
  end

  it "should allow non-friends to post on the wall" do
    jdata = JSON.generate({"body"=>"test","appId"=>0,
                           "activityObjects"=>[{
                                                   "objectTitle"=>"posting wallpost only on friends wall",
                                                   "type"=>"WALL_POST"}],
                           "title"=>"posting wallpost only on friends wall",
                           "actorType"=>"PERSON",
                           "verb"=>"POST",
                           "actorId"=>"1778592",
                           "targets"=>[{"type"=>"PERSON","objectId"=>"#{person_id}"}]})
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self?st=1778592:1778592:0:ign.com:my.ign.com:0:0", jdata, {:content_type => 'application/json'}
    wallpost_activity_id= JSON.parse(response.body)["entry"]
    puts wallpost_activity_id
  end

  it "should return valid response code for activities @self" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    puts "Got valid response code for activities @self for aggregationtester03"
  end

  it "should match the wallpost activityid with actorId @self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should eql(data["entry"][0]["id"])
    puts "Matched the wallpost activityid with actorId @self"
  end

  it "should match wall post activityid from post with target" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{nickname}/@self"
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

  it "should check that wallpost is deleted from actor" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1778592/@self"
    data = JSON.parse(response.body)
    wallpost_activity_id.should_not eql(data["entry"][0]["id"])
    puts "Verified that the wallpost is deleted from actor"
  end
end

