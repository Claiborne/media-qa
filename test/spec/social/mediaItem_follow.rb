require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "mediaItemfollow" do
people_activity_id = ""
mediaItem_id = 65500
verb = "FOLLOW"
actorType = "PERSON"
wishList = true
released = true
unreleased = false
rating = "6"

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

it "should follow the mediaItem" do
jdata = JSON.generate({"id"=>"65500"})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self?st=1722561:1722561:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
mediaItem_activity_id= JSON.parse(response.body)["entry"]
#puts $mediaItem_activity_id
 end

  it "should return valid response code for mediaItem endpoint all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@all"
   response.code.should eql(200)
   data = JSON.parse(response.body)
puts data
  #puts "Verified that got  valid response code"
  end
  
  it "should return valid response code for mediaItem wishlist" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@wishlist"
     response.code.should eql(200)
     data = JSON.parse(response.body)
  end
  
  it "should return valid response code for people collection" do
       response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@collection"
       response.code.should eql(200)
       data = JSON.parse(response.body)
  end
  
    it "should return valid response code for activities" do
         response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregation3/@self"
         response.code.should eql(200)
         data = JSON.parse(response.body)
  end
  
  it "should return the mediaItem with all" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@all"
     data = JSON.parse(response.body)
puts data
     mediaItem_id.should eql(data["entry"][0]["id"])
     #mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
     wishList.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
     unreleased.should eql(data["entry"][0]["isReleased"])
     puts "Verified that matches the mediaItemId in both entry and mediaItemSetting all"
  end 
  
   it "should match the tags with wishlist" do
       response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@wishlist"
       data = JSON.parse(response.body)
       mediaItem_id.should eql(data["entry"][0]["id"])
       #mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"][0]["id"])
       wishList.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
       unreleased.should eql(data["entry"][0]["isReleased"])
       puts "Verified that matches the mediaItemId in both entry and mediaItemSetting wishlist"
  end
  
  #it "should match the tags with collection" do
         #response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@collection"
         #data = JSON.parse(response.body)
         #mediaItem_id.should_not eql(data["entry"][0]["id"])
         #mediaItem_id.should_not eql(data["entry"][0]["mediaItemSetting"][0]["id"])
         #wishList.should_not eql(data["entry"][0]["mediaItemSetting"][0]["isWishList"])
         #unreleased.should_not eql(data["entry"][0]["isReleased"])
         #puts "Verified that matches the mediaItemId in both entry and mediaItemSetting wishlist"
  #end
  
it "should match objectId, actorType and verb in activities" do
   sleep(10)
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregation3/@self"
   data = JSON.parse(response.body)
   mediaItem_id.should eql(data["entry"][0]["activityObjects"][0]["objectId"])
   verb.should eql(data["entry"][0]["verb"])
   actorType.should eql(data["entry"][0]["actorType"])
   puts "Verified that the objectId actorType and verb in activities"
end


it "should update the mediaItem" do
 jdata = JSON.generate([{"id"=>"65500","isWishList" => "false", "showInNewsfeed"=> "true", "rating" => 6}])
 response = RestClient.put "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self?st=1722561:1722561:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
 mediaItem_activity_id= JSON.parse(response.body)["entry"]
end

it "should match the mediaItemId, rating, wishlist the actor is following" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@all"
     data = JSON.parse(response.body)
     mediaItem_id.should eql(data["entry"][0]["id"])
     mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
     wishList.should_not eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
     released.should eql(data["entry"][0]["isReleased"])
     rating.should eql(data["entry"][0]["userRating"])
     puts "Verified that matches the tags the actor is following"
  end
 
   it "should match the tags with collection" do
        response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@collection"
        data = JSON.parse(response.body)
puts data
        mediaItem_id.should eql(data["entry"][0]["id"])
        mediaItem_id.should eql(data["entry"][0]["mediaItemSetting"]["id"])
        wishList.should eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
        unreleased.should eql(data["entry"][0]["isReleased"])
        puts "Verified that matches the mediaItemId in both entry and mediaItemSetting collection"
   end
   
   it "should match the tags with wishlist" do
          response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@wishlist"
          data = JSON.parse(response.body)
          mediaItem_id.should_not eql(data["entry"][0]["id"])
          mediaItem_id.should_not eql(data["entry"][0]["mediaItemSetting"]["id"])
          wishList.should_not eql(data["entry"][0]["mediaItemSetting"]["isWishList"])
          unreleased.should_not eql(data["entry"][0]["isReleased"])
          puts "Verified that matches the mediaItemId in both entry and mediaItemSetting wishlist"
  end
  
it "should unfollow the mediaitem" do
   response = RestClient.delete "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/1722561/@self/#{mediaItem_id}?st=1722561:1722561:0:ign.com:my.ign.com:0:0"
   data = JSON.parse(response.body)
  puts response.body
end

it "should delete the mediaItem from all" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@all"
  data = JSON.parse(response.body)
  mediaItem_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the mediaItem is removed from all"
end

it "should delete mediaItem from wishlist" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@wishlist"
  data = JSON.parse(response.body)
  mediaItem_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the mediaItem is removed from wishlist"
end

it "should delete mediaItem from collection" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/mediaItems/nickname.aggregation3/@self/@collection"
  data = JSON.parse(response.body)
  mediaItem_id.should_not eql(data["entry"][0]["id"])
  puts "Verified that the mediaItem is removed from collection"
end

it "should delete mediaItem from activities" do
  sleep(5)
  response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.aggregation3/@self"
  data = JSON.parse(response.body)
  mediaItem_id.should_not eql(data["entry"][0]["id"])
  puts "verified that mediaItem is removed from activities"
end
end

