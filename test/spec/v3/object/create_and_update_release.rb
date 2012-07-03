require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'post_search/object_post_search'
require 'topaz_token'

include Assert
include ObjectPostSearch
include TopazToken

class HelperVars

  @token = return_topaz_token('objects')

  @number = Random.rand(10000).to_s

  @release_id = ""

  def self.return_token
    @token
  end

  def self.return_number
    @number
  end

  def self.return_object_slug(object_type)
    "qa-test-#{object_type}-#{@number}"
  end

  def self.return_release_id
    @release_id
  end

  def self.set_release_id(id)
    @release_id = id
  end

end

def common_checks

  it "should return 200" do
  end

  it "should return a releaseId key" do
    @data.has_key?('releaseId').should be_true
  end

  it "should return a releaseId value that is a 24-character hash" do
    @data['releaseId'].match(/^[0-9a-f]{24}$/).should be_true
  end

end

# CREATE DRAFT
# CHECK
# UPDATE DRAFT
# CHECK
# UPDATE TO PUBLISHED
# CHECK
# UPDATE TO ADD ALL INFO
# CHECK

# CLEAN UP / DELETE RELEASE

####################################################################

describe "V3 Object API -- Create Draft Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases?oauth_token=#{HelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_release_draft(HelperVars.return_number), :content_type => "application/json"
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
  end

  it "should return a releaseId key" do
    @data.has_key?('releaseId').should be_true
  end

  it "should return a releaseId value that is a 24-character hash" do
    @data['releaseId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_release_id @data['releaseId']
  end

end

####################################################################

describe "V3 Object API -- Check Draft Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}"
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

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'draft'" do
    @data['metadata']['state'].should == 'draft'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

end

####################################################################

describe "V3 Object API -- Update Draft Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}?oauth_token=#{HelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_release_draft, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################

describe "V3 Object API -- Check Updated Draft Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}"
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

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'draft'" do
    @data['metadata']['state'].should == 'draft'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

end

####################################################################

describe "V3 Object API -- Update Draft Release To Published", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}?oauth_token=#{HelperVars.return_token}"
    begin
      @response = RestClient.put @url, {:metadata=>{:state=>"published"}}.to_json, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################

describe "V3 Object API -- Check Updated Published Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}"
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

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'published'" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

end

####################################################################

describe "V3 Object API -- Update Published", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}?oauth_token=#{HelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_release_published(
        JSON.parse(RestClient.get("http://10.92.218.26:8080/games/slug/mass-effect-3").body)['gameId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/companies/slug/bioware").body)['companyId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/companies/slug/bioware").body)['companyId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/features/slug/1080i").body)['featureId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/features/slug/1080i").body)['featureId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/genres/slug/action").body)['genreId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/genres/slug/action").body)['genreId'].to_s,
        JSON.parse(RestClient.get("http://10.92.218.26:8080/hardware/slug/xbox-360").body)['hardwareId'].to_s
      ),
      :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################

describe "V3 Object API -- Check Updated Published", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}"
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

  common_checks

  it "should return a releaseId value of #{HelperVars.return_release_id}" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'published'" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

  {:date => '2012-03-06', :display => 'March 6, 2012', :status => 'released'}.each do |k,v|
    it "should return a metadata.releaseDate.#{k} value of '#{v}'" do
      @data['metadata']['releaseDate'][k.to_s].should == v
    end
  end

  {:description => 'qa-test description', :shortDescription => 'qa-test shortDescription', :alternateNames => ["qa-test alternateNames 1", "qa-test alternateNames 2"]}.each do |k,v|
    it "should return a metadata.#{k} value of #{v}" do
      @data['metadata'][k.to_s].should == v
    end
  end

  it "should return a metadata.game.gameId value that is a 24-character hash"
    #@data['releaseId'].match(/^[0-9a-f]{24}$/).should be_true

  it "should return a non-nil, non-blank metadata.game.metadata.legacyId value"
    # dont do this. instead compare against company data

  it "should return a metadata.game.metadata.slug with a value of 'mass-effect-3'"
    # dont do this. instead compare against company data

  %w(publishers, developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.companyId value"
    # dont do this. instead compare against company data
  end

  %w(publishers, developers).each do |company|
    it "should return a companies.#{company}.metadata.name with a value of 'BioWare'"
    # dont do this. instead compare against company data
  end

  %w(publishers, developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.description value"
    # dont do this. instead compare against company data
  end

  %w(publishers, developers).each do |company|
    it "should return a companies.#{company}.metadata.slug with a value of 'bioware'"
    # dont do this. instead compare against company data
  end

  %w(publishers, developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.description value"
    # dont do this. instead compare against company data
  end

end

####################################################################

describe "V3 Object API -- Clean up / Delete", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}?oauth_token=#{HelperVars.return_token}"
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

  common_checks

  it "should return a 404 when requesting the release deleted from the service" do
    expect {RestClient.get "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}"}.to raise_error(RestClient::ResourceNotFound)
  end

end