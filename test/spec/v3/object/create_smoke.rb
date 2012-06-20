require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

class HelperVars
  
  @token = return_topaz_token('objects')
  
  @number = Random.rand(10000).to_s
  
  @object = {}.to_json
  
  def self.return_token
    @token
  end
  
  def self.return_number
    @number
  end
  
  def self.set_object(o)
    @object = o
  end
  
  def self.return_object
    @object
  end
  
end

def basic_checks(objectId)
  
  it "should not return blank data" do
    check_not_blank HelperVars.return_object
  end
  
  it "should return a #{objectId} key" do
    HelperVars.return_object.has_key?(objectId).should be_true
  end

  it "should return a #{objectId} value that is a 24-character hash" do
    HelperVars.return_object[objectId].match(/^[0-9a-f]{24,32}$/).should be_true
  end
  
  it "should autogenerate metadata.legacyId field" do
    HelperVars.return_object.has_key?('metadata').should be_true
    HelperVars.return_object['metadata'].has_key?('legacyId').should be_true
  end
  
  it "should autogenerate metadata.legacyId value" do
    HelperVars.return_object['metadata']['legacyId'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  ['createdAt','updatedAt'].each do |val|
    it "should autogenerate system.#{val} field" do
      HelperVars.return_object.has_key?('system').should be_true
      HelperVars.return_object['system'].has_key?(val).should be_true
    end
  
    it "should autogenerate system.#{val} value" do
      HelperVars.return_object['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
end

############################# BEGIN SPEC #############################

describe "V3 Object API -- Create Release Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('release'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/releases?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('release'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Release Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_release, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/releases/#{@data['releaseId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'releaseId'
  
  it "should autogenerate metadata.state field" do
    HelperVars.return_object.has_key?('metadata').should be_true
    HelperVars.return_object['metadata'].has_key?('state').should be_true
  end
  
  it "should autogenerate metadata.state value" do
    HelperVars.return_object['metadata']['state'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should autogenerate metadata.state with a value of 'draft'" do
    HelperVars.return_object['metadata']['state'].should == 'draft'
  end
  
end

###############################################################

describe "V3 Object API -- Create Game Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/games?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('game'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/games?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('game'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Game Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/games?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_game, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/games/#{@data['gameId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'gameId'
  
end

###############################################################

describe "V3 Object API -- Create Company Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Company Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_object('company'), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/companies/#{@data['companyId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'companyId'
  
end

###############################################################

describe "V3 Object API -- Create Feature Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Feature Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_object('feature'), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/features/#{@data['featureId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'featureId'
  
end

###############################################################

describe "V3 Object API -- Create Genre Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Genre Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_object('genre'), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/genres/#{@data['genreId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'genreId'
  
end

###############################################################

describe "V3 Object API -- Create Hardware Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Hardware Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_object('hardware'), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/hardware/#{@data['hardwareId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'hardwareId'
  
end

###############################################################

describe "V3 Object API -- Create Market Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_name('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_name('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
    expect { RestClient.post @url, create_object_with_zero_length_slug('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
      expect { RestClient.post @url, create_object_no_slug('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Market Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_valid_object('market'), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://10.92.218.26:8080/markets/#{@data['marketId']}"
      check_200 response
      HelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end       
  end
  
  basic_checks 'marketId'
  
end

########################## JSON BODY FOR WRITES ##########################

########## CREATE VALID ##########

def create_valid_release
  {
    "metadata" => {
      "name" => "Media QA Test Release #{HelperVars.return_number}"
    }
  }.to_json
end

def create_valid_game
  {
    "metadata" => {
      "slug" => "media-qa-test-game-#{HelperVars.return_number}"
    }
  }.to_json
end

def create_valid_object(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{HelperVars.return_number}",
      "slug" => "media-qa-test-#{obj}-#{HelperVars.return_number}"
    }
  }.to_json
end

########## CREATE INVALID ##########

def create_object_with_zero_length_name(obj)
  {
    "metadata" => {
      "name" => "",
      "slug" => "media-qa-test-#{obj}-#{HelperVars.return_number}"
    }
  }.to_json
end


def create_object_no_name(obj)
  {
    "metadata" => {
      "slug" => "media-qa-test-#{obj}-#{HelperVars.return_number}"
    }
  }.to_json
end

def create_object_with_zero_length_slug(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{HelperVars.return_number}",
      "slug" => ""
    }
  }.to_json
end


def create_object_no_slug(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{HelperVars.return_number}"
    }
  }.to_json
end