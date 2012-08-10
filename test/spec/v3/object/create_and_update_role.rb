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

class CreateRoleMetadata

  @token = return_topaz_token('objects')

  @number = Random.rand(10000).to_s

  @role_id = ""

  def self.return_token
    @token
  end

  def self.return_number
    @number
  end

  def self.return_role_id
    @role_id
  end

  def self.set_role_id(id)
    @role_id = id
  end

end

# CREATE MINIMUM ROLE
# CHECK
# UPDATE TO ADD ALL OBJECTS
# CHECK

    # TODO
    # UPDATE (CHANGE) OBJECTS
    # CHECK

# CLEAN UP / DELETE ROLE

####################################################################
# CREATE MINIMUM ROLE

describe "V3 Object API -- Create Minimum Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateRoleMetadata.return_token}"
    begin
      @response = RestClient.post @url, create_role_min, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

    CreateRoleMetadata.set_role_id @data['roleId']

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
  end

  it "should return a roleId key" do
    @data.has_key?('roleId').should be_true
  end

  it "should return a roleId value that is a 24-character hash" do
    @data['roleId'].match(/^[0-9a-f]{24}$/).should be_true
    CreateRoleMetadata.set_role_id @data['roleId']
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Minimum Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{CreateRoleMetadata.return_role_id}"
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
  end

  it "should return a roleId key" do
    @data.has_key?('roleId').should be_true
  end

  it "should return a roleId value that is a 24-character hash" do
    @data['roleId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return metadata.lead data with a value of 'false'" do
    @data['metadata']['lead'].should == false
  end

  it "should return metadata.characterName data with a value of 'QA Character'" do
    @data['metadata']['characterName'].should == 'QA Character'
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
# UPDATE TO ADD ALL OBJECTS

describe "V3 Object API -- Update To Add All Objects To Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{CreateRoleMetadata.return_role_id}?oauth_token=#{CreateRoleMetadata.return_token}"

    @response = RestClient.put @url, update_role_with_objects(
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/slug/the-dark-knight").body)['movieId'].to_s,
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/slug/batman").body)['characterId'].to_s,
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roletypes/slug/actor").body)['roleTypeId'].to_s,
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/slug/mass-effect-3").body)['gameId'].to_s,
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/slug/batman-the-dark-knight-vol-2-issue-1").body)['bookId'].to_s,
          JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/slug/christian-bale").body)['personId'].to_s,
      ), :content_type => "application/json"
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return a roleId key" do
    @data.has_key?('roleId').should be_true
  end

  it "should return a roleId value that is a 24-character hash" do
    @data['roleId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return the expected releaseId value" do
    @data['roleId'].should == CreateRoleMetadata.return_role_id
  end

end

####################################################################
# CHECK

describe "V3 Object API -- Check Minimum Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{CreateRoleMetadata.return_role_id}"
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
  end

  it "should return a roleId key" do
    @data.has_key?('roleId').should be_true
  end

  it "should return a roleId value that is a 24-character hash" do
    @data['roleId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return metadata.lead data with a value of 'true'" do
    @data['metadata']['lead'].should == true
  end

  it "should return metadata.characterName data with a value of 'updated'" do
    @data['metadata']['characterName'].should == 'updated'
  end


  it "should return the same movie metadata as the movie returns" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{@data['metadata']['movie']['movieId']}"
    rescue => e
      raise Exception.new(e.message+" http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{@data['metadata']['movie']['movieId']}")
    end

    movie_data = JSON.parse(response.body)

    @data['metadata']['movie']['metadata'].should == movie_data['metadata']

  end

  it "should return the same character metadata as the character returns" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{@data['metadata']['character']['characterId']}"
    rescue => e
      raise Exception.new(e.message+" http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{@data['metadata']['character']['characterId']}")
    end

    character_data = JSON.parse(response.body)

    @data['metadata']['character']['metadata'].should == character_data['metadata']

  end

  it "should return the same roleType metadata as the roleType returns" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roletypes/#{@data['metadata']['roleType']['roleTypeId']}"
    rescue => e
      raise Exception.new(e.message+" http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roletypes/#{@data['metadata']['roleType']['roleTypeId']}")
    end

    roletype_data = JSON.parse(response.body)

    @data['metadata']['roleType']['metadata'].should == roletype_data['metadata']

  end

  it "should return the same game metadata as the game returns" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{@data['metadata']['game']['gameId']}"
    rescue => e
      raise Exception.new(e.message+" http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{@data['metadata']['game']['gameId']}")
    end

    game_data = JSON.parse(response.body)

    @data['metadata']['game']['metadata'].should == game_data['metadata']

  end

  it "should return the same person metadata as the person returns" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{@data['metadata']['person']['personId']}"
    rescue => e
      raise Exception.new(e.message+" http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{@data['metadata']['person']['personId']}")
    end

    person_data = JSON.parse(response.body)

    @data['metadata']['person']['metadata'].should == person_data['metadata']

  end

end

####################################################################
# CLEAN UP / DELETE RELEASE

describe "V3 Object API -- Clean up / Delete", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{CreateRoleMetadata.return_role_id}?oauth_token=#{CreateRoleMetadata.return_token}"
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

  it "should return a roleId key" do
    @data.has_key?('roleId').should be_true
  end

  it "should return a roleId value that is a 24-character hash" do
    @data['roleId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a 404 when deleting the role" do
    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{CreateRoleMetadata.return_role_id}"}.to raise_error(RestClient::ResourceNotFound)
  end

end