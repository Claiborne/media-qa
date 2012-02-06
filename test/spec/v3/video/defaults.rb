require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

[ "", 
  "state/published",
  "?metadata.state=published&metadata.networks=ign",
  "network/ign?metadata.state=published",
  "state/published?metadata.networks=ign&metadata.state=published",
  "?sortOrder=asc&sortBy=metadata.name&metadata.state=published",
  "?metadata.state=published&fields=metadata.name,metadata.networks,videoId"].each do |call|

describe "V3 Video API: Video Smoke Tests" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/#{call}"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
  
  it "shoud return count with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.length.should > 0
  end
  
  it "should return count with a value of 20" do
    @data['count'].should == 20
  end
  
  it "shoud return start with a non-nil, non-blank value" do
    @data.has_key?('start').should be_true
    @data['start'].should_not be_nil
    @data['start'].to_s.length.should > 0
  end
  
  it "should return start with a value of 0" do
    @data['start'].should == 0
  end
  
  it "shoud return end with a non-nil, non-blank value" do
    @data.has_key?('end').should be_true
    @data['end'].should_not be_nil
    @data['end'].to_s.length.should > 0
  end
  
  it "should return end with a value of 19" do
    @data['end'].should == 19
  end
  
  it "shoud return isMore with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.length.should > 0
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].should == true
  end

  it "shoud return total with a non-nil, non-blank value" do
    @data.has_key?('total').should be_true
    @data['total'].should_not be_nil
    @data['total'].to_s.length.should > 0
  end
  
  it "should return total with a value greater than 20" do
    @data['total'].should > 20
  end
  
  it "shoud return data with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.length.should > 0
  end
  
  it "should return data with an array length of 20" do
    @data['data'].length.should == 20
  end
  
  ["videoId",
    "assets",
    "thumbnails", 
    "objectRelations", 
    "metadata", 
    "tags", 
    "category"].each do |k| 
    it "should return #{k} for all videos" do
      @data['data'].each do |article|
        article.has_key?(k).should be_true
      end
    end
  end
  
  it "should not return any blank or nil values for videoId" do
    @data['data'].each do |article|
      article['videoId'].should_not be_nil
      article['videoId'].to_s.length.should > 0
    end
  end
  
  it "should return a hash value for all videoIds" do
    @data['data'].each do |video|
      video['videoId'].match(/^[0-9a-f]{24,32}$/).should be_true  
    end  
  end
  
end
end

##################################################################

##################################################################

describe "V3 Video API: Playlist Smoke Tests" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
  
  ["count","start","end","isMore","total","data"].each do |k|
    it "shoud return #{k} with a non-nil, non-blank value" do
      @data.has_key?('count').should be_true
      @data[k].should_not be_nil
      @data[k].to_s.length.should > 0
    end
  end
  
  it "should return count with a value of 20" do
    @data['count'].should == 20
  end
  
  it "should return start with a value of 0" do
    @data['start'].should == 0
  end
  
  it "should return end with a value of 19" do
    @data['end'].should == 19
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].should == true
  end
  
  it "should return total with a value greater than 20" do
    @data['total'].should > 20
  end
  
  it "should return data with an array length of 20" do
    @data['data'].length.should == 20
  end
  
  ["playlistId","metadata","system"].each do |key|
    it "should return #{key} data with a non-nil, non-blank value for all playlists" do
      @data['data'].each do |playlist|
        playlist.has_key?(key).should be_true
        playlist[key].should_not be_nil
        playlist[key].to_s.length.should > 0
      end
    end
  end
  
  ["name", "description", "url"].each do |key|
    it "should return #{key} metadata with a non-nil, non-blank value for all playlists" do
      @data['data'].each do |playlist|
        playlist['metadata'].has_key?(key).should be_true
        playlist['metadata'].should_not be_nil
        playlist['metadata'].to_s.length.should > 0
      end
    end
  end
  
end

##################################################################

##################################################################
{"Get A Single Video By Slug" => "/slug/metal-gear-solid-hd-collection-video-review",
  "Get A Single Video By videoId" => "/4eb87cb98e88c57b65000008"}.each do |k,v|

describe "V3 Video API: #{k}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos#{v}"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with 11 indices" do
    check_indices(@data, 11)
  end
  
  ["videoId",
    "assets",
    "thumbnails", 
    "objectRelations", 
    "metadata", 
    "promo",
    "tags", 
    "extra",
    "refs",
    "category",
    "system"].each do |k| 
    it "should return a video with #{k} data" do
      @data.has_key?(k).should be_true
      @data[k].should_not be_nil
      @data[k].to_s.length.should > 0
    end
  end
  
  it "should return a video with 7 assets" do
    @data['assets'].length.should == 7
  end
  
  it "should return a video with a videoId of 4eb87cb98e88c57b65000008" do
    @data['videoId'].should eql("4eb87cb98e88c57b65000008")
  end
  
  ["downloadable",
    "url",
    "bitrate",
    "height",
    "width",].each do |k| 
    it "should return #{k} asset data with a non-nil, non-blank value" do
      @data['assets'].each do |article|
        article.has_key?(k).should be_true
        article[k].should_not be_nil
        article[k].to_s.length.should > 0
      end
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return #{k} thumbnail data with a non-nil, non-blank value" do
      @data['thumbnails'].each do |article|
        article.has_key?(k).should be_true
        article[k].should_not be_nil
        article[k].to_s.length.should > 0
      end
    end
  end
  
  ["commonName",
    "objectTypeId",
    "objectName",
    "contentRating",
    "legacyId",
    "platform",
    "objectType"].each do |k|
    it "should return #{k} objectRelations data with a non-nil, non-blank value" do
      @data['objectRelations'][0].has_key?(k).should be_true
      @data['objectRelations'][0][k].should_not be_nil
      @data['objectRelations'][0][k].to_s.length.should > 0
    end
  end

  ["name",
    "description",
    "publishDate",
    "title",
    "longTitle",
    "duration",
    "url",
    "locale",
    "slug",
    "ageGate",
    "classification",
    "subClassification",
    "networks",
    "state",
    "noads",
    "prime",
    "subscription",
    "downloadable",
    "creator",
    "origin"].each do |k|
    it "should return #{k} metadata with a non-nil, non-blank value" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.length.should > 0
    end
  end

  it "should return tag data with 14 non-nil, non-blank slugs" do
    @data['tags'].each do |article|
      article.has_key?('slug').should be_true
      article['slug'].should_not be_nil
      article['slug'].to_s.length.should > 0
    end
    @data['tags'].length.should == 14
  end
  
  it "should return a video tagged as 'review' with a tagType of 'classification'" do
    @data['tags'][4].should eql({"slug"=>"review", "tagType"=>"classification", "displayName"=>"Review"})
  end
  
  ["videoSeries",
    "regions"].each do |k|
    it "should return #{k} extra data with a non-nil, non-blank value" do
      @data['extra'].has_key?(k).should be_true
      @data['extra'][k].should_not be_nil
      @data['extra'][k].to_s.length.should > 0
    end
  end
  
  ["youtubeChannelIds",
    "legacyArticleIds"].each do |k|
    it "should return #{k} refs data with a non-nil, non-blank value" do
      @data['refs'].has_key?(k).should be_true
      @data['refs'][k].should_not be_nil
      @data['refs'][k].to_s.length.should > 0
    end
  end
  
  ["encodingProfile",
    "watermarkProfile",
    "mezzanineUrl",
    "createdAt",
    "updatedAt"].each do |k|
    if k == "mezzanineUrl"
      it "should return #{k} system data with a non-nil, non-blank value", :prd => true do
        @data['system'].has_key?(k).should be_true
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.length.should > 0
      end
    else
      it "should return #{k} system data with a non-nil, non-blank value" do
        @data['system'].has_key?(k).should be_true
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.length.should > 0
      end
    end
  end

end
end

##################################################################

##################################################################


  
[ "state/published",
  "?metadata.state=published&metadata.networks=ign",
  "network/ign?metadata.state=published",
  "state/published?metadata.networks=ign",
  "?sortOrder=asc&sortBy=metadata.name&metadata.state=published",
  "?metadata.state=published&fields=metadata.name,metadata.networks,videoId,metadata.state"].each do |call|
    
describe "V3 Video API: Get Videos in Published State" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/#{call}"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
    
  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
    
  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end
end
end

##################################################################

##################################################################

[ "state/published?count=35",
  "state/published?startIndex=36&count=35",
  "network/ign?count=35&metadata.state=published",
  "network/ign?startIndex=36&count=35&metadata.state=published"].each do |call|

describe "V3 Video API: Get Videos Using Count and Start Index" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/#{call}"
    puts @url
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
    
  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
    
  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end
  
  it "should return a count value of 35" do
    @data['count'].should == 35
  end
  
  it "should return 35 videos" do
    @data['data'].length.should == 35
  end
  
  if call.match(/startIndex=36/)
    it "should return start with a value of 36" do
      @data['start'].should == 36
    end
    
    it "should return end with a value of 70" do
      @data['end'].should == 70
    end
    
  end
end
end







