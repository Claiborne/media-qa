#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'
require 'oauth'

describe "blog" do
blog_activity_id = ""
comment_activity_id = ""
comment_type = "COMMENT"
blog_type = "BLOG_ENTRY"
  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
    
 end

  after(:each) do

  end

it "should post the blog" do
jdata = JSON.generate({"actorId" => "1557918",
   "title" => "tchandrada has created a blog",
   "body" => "Test post content.",
   "actorType" => "PERSON",
   "verb" => "POST",
   "activityObjects" => [
      {
         "externalId" => "test-post",
         "objectTitle" => "Test Post",
         "type" => "BLOG_ENTRY",
         "links" => [
            {
               "rel" => "blog_entry",
               "type" => "text/html",
               "uri" => "http://www.ign.com/blogs/tchandrada/2011/08/02/tchandrada-has-created-a-blog"
            }
         ]
      }
   ]
})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
blog_activity_id= JSON.parse(response.body)["entry"]
puts blog_activity_id
 end

it "should return valid response code for activities @self" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   puts "verified it match the responsecode for activities"
  end

it "should match blog activityid from post" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   data = JSON.parse(response.body)
   blog_activity_id.should eql(data["entry"][0]["id"])
   blog_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
   puts "Verified that it matches the blog activityid"
end

it "should post the comment for the blog" do
jdata = JSON.generate({"actorId" => "1557918",
   "title" => "tchandrada has commented on a blog",
   "body" => "Test post content.",
   "actorType" => "PERSON",
   "verb" => "POST",
   "activityObjects" => [
      {
         "externalId" => "test-post",
         "objectTitle" => "Test Post",
         "type" => "COMMENT",
         "links" => [
            {
               "rel" => "comment",
               "type" => "text/html",
               "uri" => "http://www.ign.com/blogs/tchandrada/2011/08/02/tchandrada-has-created-a-blog"
            }
         ]
      }
   ]
})
response = RestClient.post "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/1557918/@self?st=1557918:1557918:0:ign.com:my.ign.com:0:0",jdata, {:content_type => 'application/json'}
comment_activity_id = JSON.parse(response.body)["entry"]
puts comment_activity_id
end

it "should match the comment activityId" do
sleep(5)
 response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/activities/nickname.tchandrada/@self"
   data = JSON.parse(response.body)
   comment_activity_id.should eql(data["entry"][0]["id"])
   comment_type.should eql(data["entry"][0]["activityObjects"][0]["type"])
   puts "Verified that matches the comment activityid"
 end
 
 end 

