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
  
  ["name", "description", "url","networks"].each do |key|
    it "should return #{key} metadata with a non-nil, non-blank value for all playlists" do
      @data['data'].each do |playlist|
        playlist['metadata'].has_key?(key).should be_true
        playlist['metadata'].should_not be_nil
        playlist['metadata'].to_s.length.should > 0
      end
    end
  end
  
end








