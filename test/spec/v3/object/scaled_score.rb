require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'post_search/object_post_search'; include ObjectPostSearch
require 'topaz_token'

include Assert
include TopazToken

describe "V3 Object API -- Create Release Without Scaled Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, create_valid_release_published, :content_type => "application/json"
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

describe "V3 Object API -- Update Release to Remove Review Score Only", :test => true, :stg => true do

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

describe "V3 Object API -- Update Release to Add Review Score Back", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      2.times {@response = RestClient.put @url, add_score_to_release, :content_type => "application/json"} # 2 times hack b/c lift issue
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

  it "should add a scaledScore of 0.8" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.8
  end

end

describe "V3 Object API -- Clean Up", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/releases/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.delete @url
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

end