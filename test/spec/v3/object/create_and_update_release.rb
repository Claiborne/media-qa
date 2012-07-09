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
# ADD REVIEW SCORE
# CHECK
# CLEAN UP / DELETE RELEASE

####################################################################
# CREATE DRAFT

describe "V3 Object API -- Create Draft Release", :stg => true do

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
# CHECK

describe "V3 Object API -- Check Draft Release", :stg => true do

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

  it "should return the expected releaseId value" do
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
      @data['system'][val].should_not be_nil
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

end

####################################################################
# UPDATE DRAFT

describe "V3 Object API -- Update Draft Release", :stg => true do

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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Updated Draft Release", :stg => true do

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

  it "should return the expected releaseId value" do
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
      @data['system'][val].should_not be_nil
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

end

####################################################################
# UPDATE TO PUBLISHED

describe "V3 Object API -- Update Draft Release To Published", :stg => true do

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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Updated Published Release", :stg => true do

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

  it "should return the expected releaseId value" do
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
      @data['system'][val].should_not be_nil
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

end

####################################################################
# UPDATE TO ADD ALL INFO

describe "V3 Object API -- Update Published", :stg => true do

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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Updated Published", :stg => true do

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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'published'" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
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

  it "should return a metadata.game.gameId value that is a 24-character hash" do
    @data['metadata']['game']['gameId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a non-nil, non-blank metadata.game.metadata.legacyId value" do
    @data['metadata']['game']['metadata']['legacyId'].should_not be_nil
    @data['metadata']['game']['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  it "should return a metadata.game.metadata.slug with a value of 'mass-effect-3'" do
    @data['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
  end

  it "should return the same metadata.game.metadata. legacyId & slug values the game returns" do
    begin
      response = RestClient.get "http://10.92.218.26:8080/games/#{@data['metadata']['game']['gameId']}"
    rescue => e
      raise Exception.new(e.message+" http://10.92.218.26:8080/games/#{@data['metadata']['game']['gameId']}")
    end
    game_data = JSON.parse(response.body)

    @data['metadata']['game']['metadata']['legacyId'].should == game_data['metadata']['legacyId']
    @data['metadata']['game']['metadata']['slug'].should == game_data['metadata']['slug']

  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.companyId value" do
      @data['companies'][company][0]['companyId'].should_not be_nil
      @data['companies'][company][0]['companyId'].to_s.delete('^0-9').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a companies.#{company}.companyId value that is a 24-character hash" do
      @data['companies'][company][0]['companyId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.name value" do
      @data['companies'][company][0]['metadata']['name'].should_not be_nil
      @data['companies'][company][0]['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.description value" do
      @data['companies'][company][0]['metadata']['description'].should_not be_nil
      @data['companies'][company][0]['metadata']['description'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a companies.#{company}.metadata.slug with a value of 'bioware'" do
      @data['companies'][company][0]['metadata']['slug'].should == 'bioware'
    end
  end

  %w(publishers developers).each do |company|
    it "should return the same companies.#{company}.metadata. name, description, slug, & legacyId value the game returns" do
      begin
        response = RestClient.get "http://10.92.218.26:8080/companies/#{@data['companies'][company][0]['companyId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/companies/#{@data['companies'][company][0]['companyId']}")
      end
      company_data = JSON.parse(response.body)

      @data['companies'][company][0]['metadata']['name'].should == company_data['metadata']['name']
      @data['companies'][company][0]['metadata']['description'].should == company_data['metadata']['description']
      @data['companies'][company][0]['metadata']['slug'].should == company_data['metadata']['slug']
      @data['companies'][company][0]['metadata']['legacyId'].should == company_data['metadata']['legacyId']
    end
  end

  it "should return a content.features value of 'qa-test feature 1, qa-test feature 2'" do
    @data['content']['features'].should == ["qa-test feature 1", "qa-test feature 2"]
  end

  it "should return a non-blank, non-nil content.supports.featureId value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['featureId'].should_not be_nil
      content_supports['featureId'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a content.supports.featureId value that is a 24-character hash" do
    @data['content']['supports'].each do |content_supports|
      content_supports['featureId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.name value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.slug value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['slug'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.name legacyId" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return the same content.metadata name, slug & legacyId values as the feature returns" do
    @data['content']['supports'].each do |content_supports|
      begin
        response = RestClient.get "http://10.92.218.26:8080/features/#{content_supports['featureId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/features/#{content_supports['featureId']}")
      end
      feature_data = JSON.parse(response.body)

      content_supports['metadata']['name'].should == feature_data['metadata']['name']
      content_supports['metadata']['slug'].should == feature_data['metadata']['slug']
      content_supports['metadata']['legacyId'].should == feature_data['metadata']['legacyId']
    end
  end

  it "should return a content.rating.system value of 'ESRB'" do
    @data['content']['rating']['system'].should == 'ESRB'
  end

  it "should return a content.rating.summary value of 'qa-test summary'" do
    @data['content']['rating']['summary'].should == 'qa-test summary'
  end

  it "should return a content.rating.description value of 'qa-test description 1, qa-test description 2'" do
    @data['content']['rating']['description'].should == ["qa-test description 1", "qa-test description 2"]
  end

  it "should return a content.rating.rating value of 'M'" do
    @data['content']['rating']['rating'].should == 'M'
  end

  %w(primaryGenre secondaryGenre).each do |genre|

    it "should return a content.#{genre}.genreId value that is a 24-character hash" do
      @data['content'][genre]['genreId'].match(/^[0-9a-f]{24}$/).should be_true
    end

    it "should return a non-nil, non-blank content.#{genre}.metadata.legacyId value" do
      @data['content'][genre]['metadata']['legacyId'].should_not be_nil
      @data['content'][genre]['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    it "should return a non-blank, non-nil content.#{genre}.metadata.name value" do
      @data['content'][genre]['metadata']['name'].should_not be_nil
      @data['content'][genre]['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end

    it "should return a content.#{genre}.metadata.slug value of 'action'" do
      @data['content'][genre]['metadata']['slug'].should == 'action'
    end

    it "should return the same content.#{genre} name, slug & legacyId values as the genre returns" do
      begin
        response = RestClient.get "http://10.92.218.26:8080/genres/#{@data['content'][genre]['genreId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/genres/#{@data['content'][genre]['genreId']}")
      end
      genre_data = JSON.parse(response.body)

      @data['content'][genre]['metadata']['name'].should == genre_data['metadata']['name']
      @data['content'][genre]['metadata']['legacyId'].should == genre_data['metadata']['legacyId']
      @data['content'][genre]['metadata']['slug'].should == genre_data['metadata']['slug']
    end

  end # end genre iteration

  it "should return a hardware.platform.hardwareId value that is a 24-character hash" do
    @data['hardware']['platform']['hardwareId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a hardware.platform.metadata.releaseDate.date value of '2006-11-10'" do
    @data['hardware']['platform']['metadata']['releaseDate']['date'].should == '2006-11-10'
  end

  it "should return a non-nil, non-blank hardware.platform.metadata.legacyId value" do
    @data['hardware']['platform']['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  %w(name description slug shortName type).each do |hardware_field|
    it "should return a non-nil, non-blank hardware.platform.metadata.#{hardware_field} value" do
      @data['hardware']['platform']['metadata'][hardware_field].should_not be_nil
      @data['hardware']['platform']['metadata'][hardware_field].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return the same hardware.metadata name, description, slug, shortName, legacyId, type & releaseData.date values as the hardware returns" do
    begin
      response = RestClient.get "http://10.92.218.26:8080/hardware/#{@data['hardware']['platform']['hardwareId']}"
    rescue => e
      raise Exception.new(e.message+" http://10.92.218.26:8080/hardware/#{@data['hardware']['platform']['hardwareId']}")
    end
    hardware_data = JSON.parse(response.body)

    @data['hardware']["platform"]['metadata']['name'].should == hardware_data['metadata']['name']
    @data['hardware']["platform"]['metadata']['description'].should == hardware_data['metadata']['description']
    @data['hardware']["platform"]['metadata']['slug'].should == hardware_data['metadata']['slug']
    @data['hardware']["platform"]['metadata']['shortName'].should == hardware_data['metadata']['shortName']
    @data['hardware']["platform"]['metadata']['legacyId'].should == hardware_data['metadata']['legacyId']
    @data['hardware']["platform"]['metadata']['type'].should == hardware_data['metadata']['type']
    @data['hardware']["platform"]['metadata']['releaseDate']['date'].should == hardware_data['metadata']['releaseDate']['date']

  end

  {:url => "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_60w.jpg", :width => 60, :height => 85, :positionId => 19}.each do |k,v|
    it "should return a legacyData.boxArt.#{k} value of #{v}" do
      @data['legacyData']['boxArt'][0][k.to_s].should == v
    end
  end

  {:url => "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_90h.jpg", :width => 65, :height => 90, :positionId => 17}.each do |k,v|
    it "should return a legacyData.boxArt.#{k} value of #{v}" do
      @data['legacyData']['boxArt'][1][k.to_s].should == v
    end
  end

  {:guideUrl => "http://www.ign.com/wikis/mass-effect-3", :reviewUrl => "http://xbox360.ign.com/articles/121/1219445p1.html", :previewUrl => "http://comics.ign.com/articles/122/1222700p1.html"}.each do |k,v|
    it "should return a legacyData.#{k} value of #{v}" do
      @data['legacyData'][k.to_s].should == v
    end
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].should_not be_nil
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

end
####################################################################
# ADD REVIEW SCORE

describe "V3 Object API -- Update Published with Review Score", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases/#{HelperVars.return_release_id}?oauth_token=#{HelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_with_review_score, :content_type => "application/json"
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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Updated Published with Review Score", :stg => true do

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

  it "should return the expected releaseId value" do
    @data['releaseId'].should == HelperVars.return_release_id
  end

  it "should return a metadata.name value of 'Media QA Test Release #{HelperVars.return_number}'" do
    @data['metadata']['name'].should == "Media QA Test Release #{HelperVars.return_number}"
  end

  it "should return a metadata.state value of 'published'" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return a metadata.region value of 'UK'" do
    @data['metadata']['region'].should == 'UK'
  end

  it "should return a non-nil, non-blank metadata.legacyId value" do
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
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

  it "should return a metadata.game.gameId value that is a 24-character hash" do
    @data['metadata']['game']['gameId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a non-nil, non-blank metadata.game.metadata.legacyId value" do
    @data['metadata']['game']['metadata']['legacyId'].should_not be_nil
    @data['metadata']['game']['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  it "should return a metadata.game.metadata.slug with a value of 'mass-effect-3'" do
    @data['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
  end

  it "should return the same metadata.game.metadata. legacyId & slug values the game returns" do
    begin
      response = RestClient.get "http://10.92.218.26:8080/games/#{@data['metadata']['game']['gameId']}"
    rescue => e
      raise Exception.new(e.message+" http://10.92.218.26:8080/games/#{@data['metadata']['game']['gameId']}")
    end
    game_data = JSON.parse(response.body)

    @data['metadata']['game']['metadata']['legacyId'].should == game_data['metadata']['legacyId']
    @data['metadata']['game']['metadata']['slug'].should == game_data['metadata']['slug']

  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.companyId value" do
      @data['companies'][company][0]['companyId'].should_not be_nil
      @data['companies'][company][0]['companyId'].to_s.delete('^0-9').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a companies.#{company}.companyId value that is a 24-character hash" do
      @data['companies'][company][0]['companyId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.name value" do
      @data['companies'][company][0]['metadata']['name'].should_not be_nil
      @data['companies'][company][0]['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a non-nil, non-blank companies.#{company}.metadata.description value" do
      @data['companies'][company][0]['metadata']['description'].should_not be_nil
      @data['companies'][company][0]['metadata']['description'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  %w(publishers developers).each do |company|
    it "should return a companies.#{company}.metadata.slug with a value of 'bioware'" do
      @data['companies'][company][0]['metadata']['slug'].should == 'bioware'
    end
  end

  %w(publishers developers).each do |company|
    it "should return the same companies.#{company}.metadata. name, description, slug, & legacyId value the game returns" do
      begin
        response = RestClient.get "http://10.92.218.26:8080/companies/#{@data['companies'][company][0]['companyId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/companies/#{@data['companies'][company][0]['companyId']}")
      end
      company_data = JSON.parse(response.body)

      @data['companies'][company][0]['metadata']['name'].should == company_data['metadata']['name']
      @data['companies'][company][0]['metadata']['description'].should == company_data['metadata']['description']
      @data['companies'][company][0]['metadata']['slug'].should == company_data['metadata']['slug']
      @data['companies'][company][0]['metadata']['legacyId'].should == company_data['metadata']['legacyId']
    end
  end

  it "should return a content.features value of 'qa-test feature 1, qa-test feature 2'" do
    @data['content']['features'].should == ["qa-test feature 1", "qa-test feature 2"]
  end

  it "should return a non-blank, non-nil content.supports.featureId value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['featureId'].should_not be_nil
      content_supports['featureId'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a content.supports.featureId value that is a 24-character hash" do
    @data['content']['supports'].each do |content_supports|
      content_supports['featureId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.name value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.slug value" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['slug'].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return a non-blank, non-nil content.supports.metadata.name legacyId" do
    @data['content']['supports'].each do |content_supports|
      content_supports['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return the same content.metadata name, slug & legacyId values as the feature returns" do
    @data['content']['supports'].each do |content_supports|
      begin
        response = RestClient.get "http://10.92.218.26:8080/features/#{content_supports['featureId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/features/#{content_supports['featureId']}")
      end
      feature_data = JSON.parse(response.body)

      content_supports['metadata']['name'].should == feature_data['metadata']['name']
      content_supports['metadata']['slug'].should == feature_data['metadata']['slug']
      content_supports['metadata']['legacyId'].should == feature_data['metadata']['legacyId']
    end
  end

  it "should return a content.rating.system value of 'ESRB'" do
    @data['content']['rating']['system'].should == 'ESRB'
  end

  it "should return a content.rating.summary value of 'qa-test summary'" do
    @data['content']['rating']['summary'].should == 'qa-test summary'
  end

  it "should return a content.rating.description value of 'qa-test description 1, qa-test description 2'" do
    @data['content']['rating']['description'].should == ["qa-test description 1", "qa-test description 2"]
  end

  it "should return a content.rating.rating value of 'M'" do
    @data['content']['rating']['rating'].should == 'M'
  end

  %w(primaryGenre secondaryGenre).each do |genre|

    it "should return a content.#{genre}.genreId value that is a 24-character hash" do
      @data['content'][genre]['genreId'].match(/^[0-9a-f]{24}$/).should be_true
    end

    it "should return a non-nil, non-blank content.#{genre}.metadata.legacyId value" do
      @data['content'][genre]['metadata']['legacyId'].should_not be_nil
      @data['content'][genre]['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    it "should return a non-blank, non-nil content.#{genre}.metadata.name value" do
      @data['content'][genre]['metadata']['name'].should_not be_nil
      @data['content'][genre]['metadata']['name'].to_s.delete('^a-zA-Z').length.should > 0
    end

    it "should return a content.#{genre}.metadata.slug value of 'action'" do
      @data['content'][genre]['metadata']['slug'].should == 'action'
    end

    it "should return the same content.#{genre} name, slug & legacyId values as the genre returns" do
      begin
        response = RestClient.get "http://10.92.218.26:8080/genres/#{@data['content'][genre]['genreId']}"
      rescue => e
        raise Exception.new(e.message+" http://10.92.218.26:8080/genres/#{@data['content'][genre]['genreId']}")
      end
      genre_data = JSON.parse(response.body)

      @data['content'][genre]['metadata']['name'].should == genre_data['metadata']['name']
      @data['content'][genre]['metadata']['legacyId'].should == genre_data['metadata']['legacyId']
      @data['content'][genre]['metadata']['slug'].should == genre_data['metadata']['slug']
    end

  end # end genre iteration

  it "should return a hardware.platform.hardwareId value that is a 24-character hash" do
    @data['hardware']['platform']['hardwareId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a hardware.platform.metadata.releaseDate.date value of '2006-11-10'" do
    @data['hardware']['platform']['metadata']['releaseDate']['date'].should == '2006-11-10'
  end

  it "should return a non-nil, non-blank hardware.platform.metadata.legacyId value" do
    @data['hardware']['platform']['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
  end

  %w(name description slug shortName type).each do |hardware_field|
    it "should return a non-nil, non-blank hardware.platform.metadata.#{hardware_field} value" do
      @data['hardware']['platform']['metadata'][hardware_field].should_not be_nil
      @data['hardware']['platform']['metadata'][hardware_field].to_s.delete('^a-zA-Z').length.should > 0
    end
  end

  it "should return the same hardware.metadata name, description, slug, shortName, legacyId, type & releaseData.date values as the hardware returns" do
    begin
      response = RestClient.get "http://10.92.218.26:8080/hardware/#{@data['hardware']['platform']['hardwareId']}"
    rescue => e
      raise Exception.new(e.message+" http://10.92.218.26:8080/hardware/#{@data['hardware']['platform']['hardwareId']}")
    end
    hardware_data = JSON.parse(response.body)

    @data['hardware']["platform"]['metadata']['name'].should == hardware_data['metadata']['name']
    @data['hardware']["platform"]['metadata']['description'].should == hardware_data['metadata']['description']
    @data['hardware']["platform"]['metadata']['slug'].should == hardware_data['metadata']['slug']
    @data['hardware']["platform"]['metadata']['shortName'].should == hardware_data['metadata']['shortName']
    @data['hardware']["platform"]['metadata']['legacyId'].should == hardware_data['metadata']['legacyId']
    @data['hardware']["platform"]['metadata']['type'].should == hardware_data['metadata']['type']
    @data['hardware']["platform"]['metadata']['releaseDate']['date'].should == hardware_data['metadata']['releaseDate']['date']

  end

  {:url => "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_60w.jpg", :width => 60, :height => 85, :positionId => 19}.each do |k,v|
    it "should return a legacyData.boxArt.#{k} value of #{v}" do
      @data['legacyData']['boxArt'][0][k.to_s].should == v
    end
  end

  {:url => "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_90h.jpg", :width => 65, :height => 90, :positionId => 17}.each do |k,v|
    it "should return a legacyData.boxArt.#{k} value of #{v}" do
      @data['legacyData']['boxArt'][1][k.to_s].should == v
    end
  end

  {:guideUrl => "http://www.ign.com/wikis/mass-effect-3", :reviewUrl => "http://xbox360.ign.com/articles/121/1219445p1.html", :previewUrl => "http://comics.ign.com/articles/122/1222700p1.html"}.each do |k,v|
    it "should return a legacyData.#{k} value of #{v}" do
      @data['legacyData'][k.to_s].should == v
    end
  end

  ['createdAt','updatedAt'].each do |val|
    it "should return a non-nil, non-blank system.#{val} value" do
      @data['system'][val].should_not be_nil
      @data['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  # Additional assertions for added review data:

  it "should return network.ign.review.metadata.publishDate data with a value of '2012-03-06T08:00:00+0000'" do
    @data['network']['ign']['review']['metadata']['publishDate'].should == '2012-03-06T08:00:00+0000'
  end

  {:system => 'ign-games', :score => 9.5 , :editorsChoice => true}.each do |k,v|
    it "should return a network.ign.review.#{v} value of #{v}" do
      @data['network']['ign']['review'][k.to_s].should == v
    end
  end

end

####################################################################
# CLEAN UP / DELETE RELEASE

describe "V3 Object API -- Clean up / Delete", :stg => true do

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