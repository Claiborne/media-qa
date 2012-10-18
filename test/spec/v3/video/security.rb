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

# SINGLE ENDPOINTS
  #

##################################################################
# GET VIDEO USING STATE/STATE

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For 'state/#{state}' Videos", :test => true do

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
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Videos", :test => true do

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
# POST VIDEO SEARCH USING STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Videos", :test => true do

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
# GET VIDEO SEARCH USING STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Videos", :test => true do

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
# GET PLAYLIST USING ?METADATA.STATE=STATE W/0 OAUTH

%w(draft).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Playlists", :test => true do

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
# POST PLAYLIST SEARCH USING STATE W/0 OAUTH

%w(draft).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Playlists", :test => true do
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
# GET PLAYLIST SEARCH USING STATE W/0 OAUTH

%w(draft).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Playlists", :test => true do
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
# GET PLAYLIST USING ?METADATA.STATE=STATE W/0 OAUTH

%w(draft).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Playlists", :test => true do

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
# GET VIDEO USING STATE/STATE W/O OAUTH

describe "V3 Object API -- GET Specific Draft & Deleted Object", :stg1 => true do

  before(:all) do
    TopazToken.set_token('objects')
    @base_url = "http://staging-videoapi.ign.com/v3/videos/"
  end

  before(:each) do

  end

  after(:each) do

  end

end