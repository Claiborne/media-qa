require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

[ "", 
  "/state/published",
  "?metadata.state=published&metadata.networks=ign",
  "/network/ign?metadata.state=published",
  "/state/published?metadata.networks=ign&?metadata.state=published",
  "?sortOrder=asc&sortBy=metadata.name&?metadata.state=published",
  "?metadata.state=published&fields=metadata.name,metadata.networks,videoId"].each do |call|
##################################################################

##################################################################

describe "V3 Video API: Smoke Tests" do

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
    @data['count'].should_not be_nil
    @data['count'].to_s.length.should > 0
  end
  
  it "should return count with a value of 20" do
    @data['count'].should == 20
  end
  
  it "shoud return start with a non-nil, non-blank value" do
    @data['start'].should_not be_nil
    @data['start'].to_s.length.should > 0
  end
  
  it "should return start with a value of 0" do
    @data['start'].should == 0
  end
  
  it "shoud return end with a non-nil, non-blank value" do
    @data['end'].should_not be_nil
    @data['end'].to_s.length.should > 0
  end
  
  it "should return end with a value of 19" do
    @data['end'].should == 19
  end
  
  it "shoud return isMore with a non-nil, non-blank value" do
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.length.should > 0
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].should == true
  end
  
  it "shoud return total with a non-nil, non-blank value" do
    @data['total'].should_not be_nil
    @data['total'].to_s.length.should > 0
  end
  
  it "should return total with a value greater than 20" do
    @data['total'].should > 20
  end
  
  it "shoud return data with a non-nil, non-blank value" do
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

describe "V3 Video API: Get A Single Video By Slug" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/slug/metal-gear-solid-hd-collection-video-review"
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
    it "should return a video with a #{k} key" do
      @data[k].should_not be_nil
      @data[k].to_s.length.should > 0
    end
  end
  
  it "should return 7 assets" do
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
    it "should return a #{k} key for each asset" do
      @data['assets'].each do |article|
        article.has_key?(k).should be_true
      end
    end
  end
  
  ["downloadable",
    "url",
    "bitrate",
    "height",
    "width",].each do |k| 
    it "should return a non-nil, non-blak value for the #{k} key of each asset" do
      @data['assets'].each do |article|
        article[k].should_not be_nil
        article[k].to_s.length.should > 0
      end
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return a #{k} key for each thumbnail" do
      @data['thumbnails'].each do |article|
        article.has_key?(k).should be_true
      end
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return a non-nil, non-blank value for the #{k} key of each thumbnail" do
      @data['thumbnails'].each do |article|
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
    it "should return a non-nil, non-blank value for the #{k} key of each objectRelations" do
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
    it "should return a non-nil, non-blank value for the #{k} key in metadata" do
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.length.should > 0
    end
  end

  it "should return 14 slugs for tags" do
    @data['tags'].each do |article|
      article.has_key?('slug').should be_true
    end
    @data['tags'].length.should == 14
  end

  it "should return a non-nil, non-blank value for the slug keys in tags" do
    @data['tags'].each do |article|
      article['slug'].should_not be_nil
      article['slug'].to_s.length.should > 0
    end
  end
  
  it "should return an article tagged as 'review' with a tagType of 'classification'" do
    @data['tags'][4].should eql({"slug"=>"review", "tagType"=>"classification", "displayName"=>"Review"})
  end
  
  ["videoSeries",
    "regions"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in extra" do
      @data['extra'][k].should_not be_nil
      @data['extra'][k].to_s.length.should > 0
    end
  end
  
  ["youtubeChannelIds",
    "legacyArticleIds"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in refs" do
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
      it "should return a non-nil, non-blank value for the #{k} key in system", :prd => true do
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.length.should > 0
      end
    else
      it "should return a non-nil, non-blank value for the #{k} key in system" do
        @data['system'][k].should_not be_nil
        @data['system'][k].to_s.length.should > 0
      end
    end
  end

end

##################################################################

##################################################################

describe "V3 Video API: Get Published Videos in Published State using /state/published" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/state/published"
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






