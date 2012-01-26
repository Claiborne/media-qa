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
  
   #['json','xml'].each do |format|
    it "should return videos in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos"
     response.code.should eql(200)
     #if format.eql?("json")
      #data = JSON.parse(response.body)
      #data.length.should > 0
     #else format.eql?("xml")
      #data = Nokogiri::XML(response.body)
      data.to_s.length.should > 0
    #end
    #end
  end

  it "should return videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return 20 videos" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.each do |entry|
     first_page_items << entry["id"] 
   end
  first_page_items.length.should eql 20
  puts first_page_items.length
   data.length.should > 0
  end
  
  it "should return videos by page" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos?startIndex=21&endIndex="
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
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos?count=10"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.each do |entry|
     total_items = total_items + 1 
   end
   puts total_items
   total_items.should eql(10)
   data.length.should > 0
  end
  
  it "should return videos with the name filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/slug/final-test"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0

  end
  
  it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/askmen"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
   it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
   it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
 
   it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/fileplanet"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
   it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/ign,gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return videos with network filter" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/ign,fileplanet"
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
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos?sortOrder=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all publshed videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/state/pubished"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all draft videos " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/state/draft"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all ign network videos " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/ign"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all gspy network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all ign,gspy network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/ign,gspy"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
  
  it "should return all fileplanet network videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos/network/fileplanet"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data.length.should > 0
  end
 
end