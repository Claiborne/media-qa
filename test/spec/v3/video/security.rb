require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'video_api_helper'
require 'topaz_token'

include Assert
include VideoApiHelper
include TopazToken

# GET VIDEO USING STATE/STATE
# GET VIDEO USING ?METADATA.STATE=STATE
# POST VIDEO SEARCH USING STATE
# GET VIDEO SEARCH USING STATE
# GET PLAYLIST USING ?METADATA.STATE=STATE
# POST PLAYLIST SEARCH USING STATE
# GET PLAYLIST SEARCH USING STATE
# GET PLAYLIST USING ?METADATA.STATE=STATE

# GET SINGLE VIDEO USING ID AND SLUG
  # CREATE
  # GET VIDEO BY ID WITH OAUTH
  # GET VIDEO BY SLUG  WITH OAUTH
  # GET VIDEO BY ID WITHOUT OAUTH
  # GET VIDEO BY SLUG  WITHOUT OAUTH


##################################################################
# GET VIDEO USING STATE/STATE

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For 'state/#{state}' Videos" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/state/#{state}?count=200"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET VIDEO USING ?METADATA.STATE=STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Videos" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos?metadata.state=#{state}&count=200"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# POST VIDEO SEARCH USING STATE

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Videos" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.post @url, get_videos_by_state(state), :content_type => "application/json"}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.post @url+"?oauth_token=#{TopazToken.return_token}", get_videos_by_state(state), :content_type => "application/json"
    res.code.should == 200
  end

end end

##################################################################
# GET VIDEO SEARCH USING STATE

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Videos" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q=#{get_videos_by_state(state)}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET PLAYLIST USING ?METADATA.STATE=STATE

%w(draft).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Playlists" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists?metadata.state=#{state}&count=75"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# POST PLAYLIST SEARCH USING STATE

%w(draft).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Playlists" do
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.post @url, get_playlists_by_state(state), :content_type => "application/json"}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.post @url+"?oauth_token=#{TopazToken.return_token}", get_playlists_by_state(state), :content_type => "application/json"
    res.code.should == 200
  end

end end

##################################################################
# GET PLAYLIST SEARCH USING STATE

%w(draft).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Playlists" do
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search?q=#{get_playlists_by_state(state)}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET PLAYLIST USING ?METADATA.STATE=STATE

%w(draft).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Playlists" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists?metadata.state=#{state}&count=200"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET SINGLE VIDEO USING ID AND SLUG

describe "V3 Video API -- GET Specific Non-Published Video", :stg => true do

  before(:all) do
    TopazToken.set_token('videos')
    @base_url = "http://staging-videoapi.ign.com/v3/videos/"

    @rand_num = Random.rand(500)
    @vid_body = {"metadata"=>{"name"=>"media qa test #{@rand_num}","slug"=>"media-qa-test-#{@rand_num}","networks"=>["abc"]},"state"=>"discovered"}.to_json

    class Vid
      @video_id = "No ID"
      def self.video_id=(value)
        @video_id = value
      end
      def self.video_id
        @video_id
      end
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should create a video" do
    res = RestClient.post "#{@base_url}?oauth_token=#{TopazToken.return_token}", @vid_body, :content_type => "application/json"
    data = JSON.parse(res.body)
    puts data['videoId']
    Vid.video_id = @video_id = data['videoId']
    res.code.should == 201
  end

  %w(discovered copying draft publishing publish_in_future abc failed).each do |state|

    it "should change the video to state=#{state}" do
      body = {"metadata"=>{"state"=>"#{state}"}}.to_json
      res = RestClient.put "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}", body, :content_type => "application/json"
      res.code.should == 200
    end

    it "should return a 200 when trying to GET a #{state} video by videoId with OAuth" do
      res = RestClient.get "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}&fresh=true"
      res.code.should == 200
      d = JSON.parse(res.body)
      d['metadata']['state'].should == state
    end

    it "should return a 200 when trying to GET a #{state} video by slug with OAuth" do
      res = RestClient.get "#{@base_url}/slug/media-qa-test-#@rand_num?oauth_token=#{TopazToken.return_token}&fresh=true"
      res.code.should == 200
      d = JSON.parse(res.body)
      d['metadata']['state'].should == state
    end

    it "should return a 401 when trying to GET a #{state} video by videoId without OAuth" do
      expect {RestClient.get "#{@base_url}#{Vid.video_id}?fresh=true"}.to raise_error(RestClient::Unauthorized)
    end

    it "should return a 401 when trying to GET a #{state} video by slug without OAuth" do
      expect {RestClient.get "#{@base_url}slug/media-qa-test-#@rand_num?fresh=true"}.to raise_error(RestClient::Unauthorized)
    end

  end

  it "should clean up" do
    res = RestClient.delete "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end

##################################################################
# GET SINGLE PLAYLIST USING ID AND SLUG

describe "V3 Video API -- GET Specific Non-Published Playlist", :stg => true do

  before(:all) do
    TopazToken.set_token('videos')
    @base_url = "http://staging-videoapi.ign.com/v3/playlists/"

    @rand_num = Random.rand(500)
    @vid_body = {"metadata"=>{"name"=>"media qa test #{@rand_num}","slug"=>"media-qa-test-#{@rand_num}","networks"=>["abc"]},"state"=>"discovered"}.to_json

    class Vid
      @video_id = "No ID"
      def self.video_id=(value)
        @video_id = value
      end
      def self.video_id
        @video_id
      end
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should create a playlists" do
    res = RestClient.post "#{@base_url}?oauth_token=#{TopazToken.return_token}", @vid_body, :content_type => "application/json"
    data = JSON.parse(res.body)
    puts data['playlistId']
    Vid.video_id = @video_id = data['playlistId']
    res.code.should == 201
  end

  %w(discovered copying draft publishing publish_in_future abc failed).each do |state|

    it "should change the playlist to state=#{state}" do
      body = {"metadata"=>{"state"=>"#{state}"}}.to_json
      res = RestClient.put "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}", body, :content_type => "application/json"
      res.code.should == 200
    end

    it "should return a 200 when trying to GET a #{state} playlist by playlistId with OAuth" do
      res = RestClient.get "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}&fresh=true"
      res.code.should == 200
      d = JSON.parse(res.body)
      d['metadata']['state'].should == state
    end

    it "should return a 200 when trying to GET a #{state} playlist by slug with OAuth" do
      res = RestClient.get "#{@base_url}/slug/media-qa-test-#@rand_num?oauth_token=#{TopazToken.return_token}&fresh=true"
      res.code.should == 200
      d = JSON.parse(res.body)
      d['metadata']['state'].should == state
    end

    it "should return a 401 when trying to GET a #{state} playlist by playlistId without OAuth" do
      expect {RestClient.get "#{@base_url}#{Vid.video_id}?fresh=true"}.to raise_error(RestClient::Unauthorized)
    end

    it "should return a 401 when trying to GET a #{state} playlist by slug without OAuth" do
      expect {RestClient.get "#{@base_url}slug/media-qa-test-#@rand_num?fresh=true"}.to raise_error(RestClient::Unauthorized)
    end

  end

  it "should clean up" do
    res = RestClient.delete "#{@base_url}#{Vid.video_id}?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end