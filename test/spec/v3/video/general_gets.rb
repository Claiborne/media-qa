require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

##################################################################

{"Get Video By Slug" => "/slug/metal-gear-solid-hd-collection-video-review",
  "Get Video By videoId" => "/4eb87cb98e88c57b65000008"}.each do |k,v|

describe "V3 Video API -- #{k} -- #{v}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos#{v}"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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
    it "should return a video with '#{k}' data" do
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
    it "should return a video with non-nil, non-blank '#{k}' asset data" do
      @data['assets'].each do |video|
        video.has_key?(k).should be_true
        video[k].should_not be_nil
        video[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return a video with non-nil, non-blank '#{k}' thumbnail data" do
      @data['thumbnails'].each do |video|
        video.has_key?(k).should be_true
        video[k].should_not be_nil
        video[k].to_s.delete("^a-zA-Z0-9").length.should > 0
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
    it "should return a video with non-nil, non-blank '#{k}' objectRelations data" do
      @data['objectRelations'][0].has_key?(k).should be_true
      @data['objectRelations'][0][k].should_not be_nil
      @data['objectRelations'][0][k].to_s.delete("^a-zA-Z0-9").length.should > 0
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
    it "should return a video with non-nil, non-blank '#{k}' metadata" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return 'tag' data with 14 non-nil, non-blank slugs" do
    @data['tags'].each do |video|
      video.has_key?('slug').should be_true
      video['slug'].should_not be_nil
      video['slug'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
    @data['tags'].length.should == 14
  end
  
  it "should return a video tagged as 'review' with a tagType of 'classification'" do
    @data['tags'][4].should eql({"slug"=>"review", "tagType"=>"classification", "displayName"=>"Review"})
  end
  
  ["videoSeries",
    "regions"].each do |k|
    it "should return a video with non-nil, non-blank '#{k}' extra data" do
      @data['extra'].has_key?(k).should be_true
      @data['extra'][k].should_not be_nil
      @data['extra'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  ["youtubeChannelIds",
    "legacyArticleIds"].each do |k|
    it "should return a video with non-nil '#{k}' refs data" do
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
      it "should return a video with non-nil, non-blank '#{k}' system data", :prd => true do
        @data['system'].has_key?(k).should be_true
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    else
      it "should return a video with non-nil, non-blank '#{k}' system data" do
        @data['system'].has_key?(k).should be_true
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end

end
end

##################################################################
  
[ "state/published?fields=metadata.state",
  "?metadata.state=published&metadata.networks=ign&fields=metadata.state",
  "network/ign?metadata.state=published&fields=metadata.state",
  "state/published?metadata.networks=ign&fields=metadata.state",
  "?sortOrder=asc&sortBy=metadata.name&metadata.state=published&fields=metadata.state",
  "?metadata.state=published&fields=metadata.name,metadata.networks,videoId,metadata.state"].each do |call|
    
describe "V3 Video API -- Get Videos in Published State -- #{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/#{call}"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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

[ "state/published?count=35&fields=metadata.state",
  "state/published?startIndex=36&count=35&fields=metadata.state",
  "network/ign?count=35&metadata.state=published&fields=metadata.state",
  "network/ign?startIndex=36&count=35&metadata.state=published&fields=metadata.state"].each do |call|

describe "V3 Video API -- Get Videos Using Count and Start Index -- #{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/#{call}"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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
  
  it "should return a 'count' value of 35" do
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

##################################################################

["/network/ign?fields=metadata.networks",
  "?metadata.networks=ign&fields=metadata.networks"].each do |call|

describe "V3 Video API -- Get Videos By Network -- #{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos#{call}"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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
  
  it "should return only videos with networks with a value of 'ign'" do
    networks_metadata = []
    @data['data'].each do |k|
      k['metadata']['networks'].each do |l|
        networks_metadata << l
      end
      networks_metadata.include?("ign").should be_true
    end
  end
  
end
end