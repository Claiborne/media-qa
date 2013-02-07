require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'object_post_search'; include ObjectPostSearch
require 'topaz_token'

include Assert
include TopazToken

## NEW FLOW

describe "V3 Object API -- Create Release With Review Data", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, create_valid_release_w_review, :content_type => "application/json"
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
    puts @data
    ObjectPostSearch.set_saved_id @data['releaseId']
    ObjectPostSearch.append_id @data['releaseId']
    puts "ARRAY: #{ObjectPostSearch.get_ids}"
  end

  it "should return correct scaledScore data" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.85

  end

end

## NEW FLOW

describe "V3 Object API -- Create Release Without Review Data", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases?oauth_token=#{TopazToken.return_token}"
    begin
      2.times {@response = RestClient.post @url, create_valid_release_published, :content_type => "application/json"} # 2 times hack b/c lift issue
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
    puts @data
    ObjectPostSearch.set_saved_id @data['releaseId']
    ObjectPostSearch.append_id @data['releaseId']
  end

  it "should not return scaledScore data" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data.to_s.match(/scaledScore/).should be_false
  end

end

describe "V3 Object API -- Add scaledScore data directly", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, add_scaled_score, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should should fail" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data.to_s.match(/scaledScore/).should be_false
  end

end

describe "V3 Object API -- Update Release With Score And Score System To Get Scaled Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      2.times {@response = RestClient.put @url, add_score_and_system_score_to_release, :content_type => "application/json"} # 2 times hack b/c lift issue
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
  end

  it "should add a scaledScore of 0.85" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.85
  end

end

describe "V3 Object API -- Update Release With Custom Scaled Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      2.times {@response = RestClient.put @url, add_scaled_score, :content_type => "application/json"} # 2 times hack b/c lift issue
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
  end

  it "should fail" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.85
  end

end

describe "V3 Object API -- Update Release to Remove Review Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      2.times {@response = RestClient.put @url, remove_review_from_release, :content_type => "application/json"} # 2 times hack b/c lift issue
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
  end

  it "should delete scaledScore data" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review'].to_json.should == {:system=>'ign-games'}.to_json
  end

end

describe "V3 Object API -- Clean Up", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should clean up and return 200" do
    raise Exception, 'v3/object/scaled_score.rb did not perform clean up' unless ObjectPostSearch.get_ids.length > 0
    ObjectPostSearch.get_ids.each do |id|
      @url = "http://apis.stg.ign.com/object/v3/releases/#{id}?oauth_token=#{TopazToken.return_token}"
      begin
        @response = RestClient.delete @url
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
    end
  end

end