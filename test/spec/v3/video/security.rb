require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'video_api_helper'

include Assert
include VideoApiHelper

shared_examples "video-api-security-without-oauth" do

  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ["count","startIndex","endIndex","isMore","data"].each do |k|
    it "shoud return '#{k}' data with a non-nil, non-blank value" do
      @data.has_key?('count').should be_true
      @data[k].should_not be_nil
      @data[k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return 'isMore' data with a value of true" do
    @data['isMore'].should == true
  end

  it "should return only published videos" do
    @data['data'].each do |video|
      video['metadata']['state'].should == 'published'
    end
  end

end

# GET VIDEO FOR STATE/STATE W/O OAUTH
# GET VIDEO FOR ?METADATA.STATE=STATE W/0 OAUTH
# POST VIDEO SEARCH FOR STATE W/0 OAUTH
# GET VIDEO SEARCH FOR STATE W/0 OAUTH
# GET PLAYLIST FOR ?METADATA.STATE=STATE W/0 OAUTH
# POST PLAYLIST SEARCH FOR STATE W/0 OAUTH
# GET PLAYLIST SEARCH FOR STATE W/0 OAUTH

##################################################################
# GET VIDEO FOR STATE/STATE W/O OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For 'state/#{state}' Videos WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/state/#{state}?count=200"
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  include_examples "video-api-security-without-oauth"

end end

##################################################################
# GET VIDEO FOR ?METADATA.STATE=STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Videos WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos?metadata.state=#{state}&count=200"
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  include_examples "video-api-security-without-oauth"

end end

##################################################################
# POST VIDEO SEARCH FOR STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Videos WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search"
    begin
      @response = RestClient.post @url, get_videos_by_state(state), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  include_examples "video-api-security-without-oauth"

end end

##################################################################
# GET VIDEO SEARCH FOR STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Videos WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q=#{get_videos_by_state(state)}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  include_examples "video-api-security-without-oauth"

end end

##################################################################
# GET PLAYLIST FOR ?METADATA.STATE=STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Ask For '?metadata.state=#{state}' Playlists WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists?metadata.state=#{state}&count=75"
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

  include_examples "video-api-security-without-oauth"

  it "should return 200 playlists" do
    @data['data'].count.should == 75
    @data['count'].should == 75
  end

end end

##################################################################
# POST PLAYLIST SEARCH FOR STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- POST Search Ask For #{state} Playlists WITHOUT OAuth" do
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search"
    begin
      @response = RestClient.post @url, get_playlists_by_state(state), :content_type => "application/json"
      puts get_playlists_by_state(state).to_s
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200 playlists", :prd => true  do
    @data['data'].count.should == 75
    @data['count'].should == 75
  end

  it "should return at least two playlists", :stg => true do
    @data['data'].count.should > 1
    @data['count'].should > 1
  end

  it "should return only published videos" do
    @data['data'].each do |video|
      video['metadata']['state'].should == 'published'
    end
  end

end end

##################################################################
# GET PLAYLIST SEARCH FOR STATE W/0 OAUTH

%w(discovered copying draft publishing publish_in_future failed).each do |state|
describe "V3 Video API -- GET Search Ask For #{state} Playlists WITHOUT OAuth", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search?q=#{get_playlists_by_state(state)}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return 200 playlists", :prd => true  do
    @data['data'].count.should == 75
    @data['count'].should == 75
  end

  it "should return at least two playlists", :stg => true do
    @data['data'].count.should > 1
    @data['count'].should > 1
  end

  it "should return only published videos" do
    @data['data'].each do |video|
      video['metadata']['state'].should == 'published'
    end
  end

end end

##################################################################


