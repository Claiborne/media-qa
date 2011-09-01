require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "videosapi" do

  first_page_items = []
  duplicate_entries= []
  total_items = 0
  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v3.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end
  
   ['json','xml'].each do |format|
    it "should return videos in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.#{format}"
     response.code.should eql(200)
     if format.eql?("json")
      data = JSON.parse(response.body)
      data.length.should > 0
     else format.eql?("xml")
      data = Nokogiri::XML(response.body)
      data.to_s.length.should > 0
    end
    end
  end

  it "should return videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return 25 videos" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.each do |entry|
     first_page_items << entry["id"] 
   end
  first_page_items.length.should eql 25 
  puts first_page_items.length
   data.length.should > 0
  end
  
  it "should return videos by page" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?page=2"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.each do |entry|
     duplicate_entries += first_page_items.find_all{ |item| item == entry["id"] } 
   end
   puts first_page_items.length
   puts duplicate_entries.length
   duplicate_entries.length.should eql(0)
   data.length.should > 0
  end
  
  it "should return ten articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?per_page=15"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.each do |entry|
     total_items = total_items + 1 
   end
   puts total_items
   total_items.should eql(15)
   data.length.should > 0
  end
  
  it "should return videos with the name filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?name=Test+publishing+episode+1002"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos with tags filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?tags=test,dvd"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos with all_tags and tags filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?all_tags=true&tags=test"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos with high_definition filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?high_definition=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
   it "should return videos sorted by name in desc order by default" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=name"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos sorted by name in asc order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=name&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos sorted by video_series in desc order by default" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=video_series"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos sorted by video_series in asc order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=video_series&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos sorted by today_views in desc order by default" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=today_views"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
    it "should return videos sorted by today_views in asc order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?sort=today_views&order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all publshed videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?state=published"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all draft videos " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?state=draft"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all ign network videos " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?network=ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all gspy network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?network=gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all ign,gspy network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?network=ign,gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all fileplanet network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?network=fileplanet"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
 
it "should return all esports network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?network=esports"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos by legacy_object_id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos.json?legact_object_id=108940"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
end