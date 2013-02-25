require 'rspec'
require 'rest_client'
require 'json'
require 'pathconfig'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

describe "follow_game" do
  person_id = ""
  people_activity_id = ""
  follow_person_id = "10000"
  verb = "FOLLOW"
  actorType = "PERSON"
  type = "Standard"
  level = "New level achieved 2"
  settings = true
  #media_activity_id = ""
  mediaItem_id = 65500
  verb = "FOLLOW"
  actorType = "PERSON"
  wishList = false
  released = true
  unreleased = false
  rating = "6"
  accounts_id = "WII_ID"
  accountType = "TOPAZ"
  followableType = "PERSON"
  gamerCard_type = "GAMER_CARD"
  topaz_id = 0
  testEmail =""



  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = PathConfig.new
    @id = "#{Random.rand(60000000-900000000)}"
    @nickname = "socialtesti2_#{Random.rand(200-9999)}"
    @joined = "#{@nickname} joined the community"
    TopazToken.set_token('social')


  end

  before(:each) do

  end

  after(:each) do
  end

  it "should register a new user" do
    @time_stamp = Time.now.to_s
    testEmail = "topaztulasi5_#{Random.rand(100-9999)}@ign.com"
    @key1 = "102353737#{Random.rand(10-1000)}"
    jdata = JSON.generate({"email"=> testEmail,"nickname"=>"#{@nickname}","accounts"=>[{"id"=> @id.to_i, "accountType"=>"topaz","key1"=> "#{@key1}","key2"=>"local"}]})
    puts jdata
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/reg",jdata, {:content_type => 'application/json'}
    puts response.body
    person_id= JSON.parse(response.body)["entry"][0]
  end

  it "should register in Topaz to get topaz Id", :test => true do
    @profileId = "#{Random.rand(3000-40000000)}"
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

  it "should get valid response for new user with topaz id" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/topaz.#{topaz_id}/@self"
    response.code.should eql(200)
  end

  it "should get valid response for new user with person id" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id.to_s}/@self"
    response.code.should eql(200)
  end

  it "should check Get people/@self is not blank" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id.to_s}/@self"
    data = JSON.parse(response.body)
    check_not_blank(data)
  end

  it "should check get with topaz id is not blank" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/topaz.#{topaz_id}/@self"
    data = JSON.parse(response.body)
    check_not_blank(data)
  end

  it "should check get with nickname is not blank" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    check_not_blank(data)
  end


  it "should check for 4 indices" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    check_indices(data, 4)
  end

  it "should check for 4 indices" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/#{person_id.to_s}/@self"
    data = JSON.parse(response.body)
    check_indices(data, 4)
  end

  it "should check for 4 indices" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/topaz.#{topaz_id}/@self"
    data = JSON.parse(response.body)
    check_indices(data, 4)
  end

  it "should match the settings fields" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnReviewCommentReceived"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnWallPostReceived"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnBlogCommentReceived"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnFacebookFriendRegistered"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnFollowerReceived"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnDailyDigest"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnPrivateMessageReceived"])
    settings.to_s.should eql (data["entry"][0]["settings"]["notifyOnLevelEarned"])
  end

  it "should match the type for people/@self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    settings.should eql (data["entry"][0]["accounts"][0]["isActive"])
    person_id.should eql (data["entry"][0]["accounts"][0]["personId"])
    accountType.to_s.should eql (data["entry"][0]["accounts"][0]["accountType"])
  end

  it "should match the nickname, followableType" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    followableType.to_s.should eql (data["entry"][0]["followableType"])
    @nickname.should eql (data ["entry"][0]["nickname"])
  end

  it "should get valid response for the new user with activities/@self" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
  end

  it "should match the personId from new registration" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    person_id.to_s().should eql(data["entry"][0]["id"])
  end


  it "should match the new level acheived" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.#{@nickname}/@self"
    data = JSON.parse(response.body)
    level.should eql(data["entry"][0]["body"])
    @joined.should eql(data["entry"][1]["body"])
  end

  it "should follow the mediaItem" do
    jdata = JSON.generate({"id"=>"65500"})
    response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self?st=#{person_id.to_s}:#{person_id.to_s}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    mediaItem_activity_id= JSON.parse(response.body)["entry"]
#puts $mediaItem_activity_id
  end

  it "should return valid response code for mediaItem endpoint all" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@all"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    #puts "Verified that got  valid response code"
  end

  it "should return valid response code for mediaItem wishlist" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@wishlist"
    response.code.should eql(200)
    data = JSON.parse(response.body)
  end

  it "should return valid response code for people collection" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@collection"
    response.code.should eql(200)
    data = JSON.parse(response.body)
  end

  it "should return valid response code for activities" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id.to_s}/@self"
    response.code.should eql(200)
    data = JSON.parse(response.body)
  end

  it "should return the mediaItem with all" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@all"
    data = JSON.parse(response.body)
    mediaItem_id.should eql(data["entry"][0]["id"])
    mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
    wishList.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
    released.should eql(data["entry"][0]["isReleased"])
    puts "Verified that matches the mediaItemId in both entry and mediaItemSetting all"
  end


  it "should match the tags with collection" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@collection"
    data = JSON.parse(response.body)
    mediaItem_id.should eql(data["entry"][0]["id"])
    mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
    wishList.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
    released.should eql(data["entry"][0]["isReleased"])
    puts "Verified that matches the mediaItemId in both entry and mediaItemSetting wishlist"
  end

  it "should match objectId, actorType and verb in activities" do
    sleep(10)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/#{person_id.to_s}/@self"
    data = JSON.parse(response.body)
    puts data["entry"][0]["activityObjects"][0]["objectId"].to_s
    mediaItem_id.to_s.should eql(data["entry"][0]["activityObjects"][0]["objectId"].to_s)
    verb.should eql(data["entry"][0]["verb"])
    actorType.should eql(data["entry"][0]["actorType"])
    puts "Verified that the objectId actorType and verb in activities"
  end


  it "should update the mediaItem" do
    jdata = JSON.generate([{"id"=>"65500","isWishList" => "false", "showInNewsfeed"=> "true", "rating" => 6}])
    response = RestClient.put "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self?st=#{person_id.to_s}:#{person_id.to_s}:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
    mediaItem_activity_id= JSON.parse(response.body)["entry"]
  end

  it "should match the mediaItemId, rating, wishlist the actor is following" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@all"
    data = JSON.parse(response.body)
    sleep(5)
    mediaItem_id.should eql(data["entry"][0]["id"])
    mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
    unreleased.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
    released.should eql(data["entry"][0]["isReleased"])
    #rating.should eql(data["entry"][0]["userRating"])
    puts "Verified that matches the tags the actor is following"
  end

  it "should unfollow the mediaitem" do
    response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/#{mediaItem_id}?st=#{person_id.to_s}:#{person_id.to_s}:0:ign.com:my.ign.com:0:0"
    data = JSON.parse(response.body)
    puts response.body
  end

  it "should delete the mediaItem from all" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@all"
    data = JSON.parse(response.body)
    0.should eql (data["totalResults"])
    puts "Verified that the mediaItem is removed from all"
  end

  it "should delete mediaItem from wishlist" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@wishlist"
    data = JSON.parse(response.body)
    0.should eql (data["totalResults"])
    puts "Verified that the mediaItem is removed from wishlist"
  end

  it "should delete mediaItem from collection" do
    sleep(5)
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/#{person_id.to_s}/@self/@collection"
    data = JSON.parse(response.body)
    0.should eql (data["totalResults"])
    puts "Verified that the mediaItem is removed from collection"
  end


end
