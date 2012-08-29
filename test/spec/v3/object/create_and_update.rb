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

class UpdateHelperVars
  
  @token = return_topaz_token('objects')
  
  @number = Random.rand(10000).to_s
  @number2 = Random.rand(10000).to_s

  @game_id = ""
  @company_id = ""
  @feature_id = ""
  @genre_id = ""
  @genre2_id = ""
  @hardware_id = ""
  @market_id = ""
  @release_id = ""
  @movie_id = ""
  @book_id = ""
  @volume_id = ""
  @role_id = ""
  @roletype_id = ""
  @person_id = ""
  @character_id = ""
  @show_id = ""
  @season_id = ""
  @episode_id = ""
  
  def self.return_token
    @token
  end
  
  def self.return_number
    @number
  end

  def self.return_number_2
    @number2
  end
  
  def self.return_object_slug(object_type,number)
    "qa-test-#{object_type}-#{number}"
  end
  
  def self.return_game_id
    @game_id
  end
  
  def self.return_company_id
    @company_id
  end
  
  def self.return_feature_id
    @feature_id
  end
  
  def self.return_genre_id
    @genre_id
  end

  def self.return_genre2_id
    @genre2_id
  end
  
  def self.return_hardware_id
    @hardware_id
  end
  
  def self.return_market_id
    @market_id
  end
  
  def self.return_release_id
    @release_id
  end

  def self.return_movie_id
    @movie_id
  end

  def self.return_book_id
    @book_id
  end

  def self.return_volume_id
    @volume_id
  end

  def self.return_role_id
    @role_id
  end

  def self.return_roletype_id
    @roletype_id
  end

  def self.return_character_id
    @character_id
  end

  def self.return_person_id
    @person_id
  end

  def self.return_show_id
    @show_id
  end

  def self.return_season_id
    @season_id
  end

  def self.return_episode_id
    @episode_id
  end
  
  # 
  
  def self.set_game_id(id)
    @game_id = id
  end
  
  def self.set_company_id(id)
    @company_id = id
  end
  
  def self.set_feature_id(id)
    @feature_id = id
  end
  
  def self.set_genre_id(id)
    @genre_id = id
  end

  def self.set_genre2_id(id)
    @genre2_id = id
  end
  
  def self.set_hardware_id(id)
    @hardware_id = id
  end
  
  def self.set_market_id(id)
    @market_id = id
  end
  
  def self.set_release_id(id)
    @release_id = id
  end

  def self.set_movie_id(id)
    @movie_id = id
  end

  def self.set_book_id(id)
    @book_id = id
  end

  def self.set_volume_id(id)
    @volume_id = id
  end

  def self.set_role_id(id)
    @role_id = id
  end

  def self.set_roletype_id(id)
    @roletype_id = id
  end

  def self.set_character_id(id)
    @character_id = id
  end

  def self.set_person_id(id)
    @person_id = id
  end

  def self.set_show_id(id)
    @show_id = id
  end

  def self.set_season_id(id)
    @season_id = id
  end

  def self.set_episode_id(id)
    @episode_id = id
  end
  
end

# FIRST SET: CREATE
    #TODO: CHECK CREATED -- OR NOT: DO ELSEWHERE? I DO WITHIN RELEASE
# SECOND SET: UPDATES
# THIRD SET: CHECK UPDATES
# CLEAN UP: DELETE OBJECTS

################################## FIRST SET: CREATE ################################## 

describe "V3 Object API -- Create Game", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_game_body(UpdateHelperVars.return_object_slug('game',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a gameId key" do
    @data.has_key?('gameId').should be_true  
  end
  
  it "should return a gameId value that is a 24-character hash" do
    @data['gameId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_game_id @data['gameId']
  end
    
end

#################################################################### 

describe "V3 Object API -- Create Company", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_company_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('company',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a companyId key" do
    @data.has_key?('companyId').should be_true  
  end

  it "should return a companyId value that is a 24-character hash" do
    @data['companyId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_company_id @data['companyId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Feature", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_feature_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('feature',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a featureId key" do
    @data.has_key?('featureId').should be_true
  end

  it "should return a featureId value that is a 24-character hash" do
    @data['featureId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_feature_id @data['featureId']
  end
  
end


####################################################################

describe "V3 Object API -- Create Genre", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_genre_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('genre',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true
  end

  it "should return a genreId value that is a 24-character hash" do
    @data['genreId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_genre_id @data['genreId']
  end

end

####################################################################

describe "V3 Object API -- Create Second Genre", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_genre_body(UpdateHelperVars.return_number_2,UpdateHelperVars.return_object_slug('genre',UpdateHelperVars.return_number_2)), :content_type => "application/json"
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

  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true
  end

  it "should return a genreId value that is a 24-character hash" do
    @data['genreId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_genre2_id @data['genreId']
  end

end

#################################################################### 

describe "V3 Object API -- Create Hardware", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_hardware_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('hardware',UpdateHelperVars.return_number),UpdateHelperVars.return_company_id), :content_type => "application/json"
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

  it "should return a hardwareId key" do
    @data.has_key?('hardwareId').should be_true
  end

  it "should return a hardwareId value that is a 24-character hash" do
    @data['hardwareId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_hardware_id  @data['hardwareId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Market", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_market_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('market',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a marketId key" do
    @data.has_key?('marketId').should be_true
  end

  it "should return a marketId value that is a 24-character hash" do
    @data['marketId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_market_id @data['marketId']
  end

end

####################################################################

describe "V3 Object API -- Create Movie", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_movie_body(UpdateHelperVars.return_object_slug('movie',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a movieId key" do
    @data.has_key?('movieId').should be_true
  end

  it "should return a movieId value that is a 24-character hash" do
    @data['movieId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_movie_id @data['movieId']
  end

end

####################################################################

describe "V3 Object API -- Create Volume", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_volume_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('volume',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a volumeId key" do
    @data.has_key?('volumeId').should be_true
  end

  it "should return a volumeId value that is a 24-character hash" do
    @data['volumeId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_volume_id @data['volumeId']
  end

end

####################################################################

describe "V3 Object API -- Create Book", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_book_body(UpdateHelperVars.return_object_slug('book',UpdateHelperVars.return_number),UpdateHelperVars.return_volume_id), :content_type => "application/json"
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

  it "should return a bookId key" do
    @data.has_key?('bookId').should be_true
  end

  it "should return a bookId value that is a 24-character hash" do
    @data['bookId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_book_id @data['bookId']
  end

end

####################################################################

describe "V3 Object API -- Create Person", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_person_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('person',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a personId key" do
    @data.has_key?('personId').should be_true
  end

  it "should return a personId value that is a 24-character hash" do
    @data['personId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_person_id @data['personId']
  end

end

####################################################################

describe "V3 Object API -- Create Character", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_character_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('character',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a characterId key" do
    @data.has_key?('characterId').should be_true
  end

  it "should return a characterId value that is a 24-character hash" do
    @data['characterId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_character_id @data['characterId']
  end

end

####################################################################

describe "V3 Object API -- Create RoleType", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_roletype_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('roletype',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a roleTypeId key" do
    @data.has_key?('roleTypeId').should be_true
  end

  it "should return a roleTypeId value that is a 24-character hash" do
    @data['roleTypeId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_roletype_id @data['roleTypeId']
  end

end

####################################################################

describe "V3 Object API -- Create Show", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_show_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('show',UpdateHelperVars.return_number)), :content_type => "application/json"
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

  it "should return a showId key" do
    @data.has_key?('showId').should be_true
  end

  it "should return a showId value that is a 24-character hash" do
    @data['showId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_show_id @data['showId']
  end

end

####################################################################

describe "V3 Object API -- Create Season", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_season_body(UpdateHelperVars.return_object_slug('season',UpdateHelperVars.return_number),UpdateHelperVars.return_show_id), :content_type => "application/json"
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

  it "should return a seasonId key" do
    @data.has_key?('seasonId').should be_true
  end

  it "should return a seasonId value that is a 24-character hash" do
    @data['seasonId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_season_id @data['seasonId']
  end

end

####################################################################

describe "V3 Object API -- Create Episode", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/episodes?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_episode_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('episode',UpdateHelperVars.return_number),UpdateHelperVars.return_show_id,UpdateHelperVars.return_season_id), :content_type => "application/json"
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

  it "should return a episodeId key" do
    @data.has_key?('episodeId').should be_true
  end

  it "should return a episodeId value that is a 24-character hash" do
    @data['episodeId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_episode_id @data['episodeId']
  end

end

####################################################################

describe "V3 Object API -- Create Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.post @url, create_role_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('role',UpdateHelperVars.return_number), UpdateHelperVars.return_movie_id, UpdateHelperVars.return_character_id, UpdateHelperVars.return_roletype_id, UpdateHelperVars.return_game_id, UpdateHelperVars.return_book_id,UpdateHelperVars.return_person_id), :content_type => "application/json"
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
    UpdateHelperVars.set_role_id @data['roleId']
  end

end

#################################################################### 

describe "V3 Object API -- Create Release", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_release_body(UpdateHelperVars.return_number,UpdateHelperVars.return_game_id,UpdateHelperVars.return_company_id,UpdateHelperVars.return_feature_id,UpdateHelperVars.return_genre_id,UpdateHelperVars.return_genre2_id,UpdateHelperVars.return_hardware_id,UpdateHelperVars.return_market_id,UpdateHelperVars.return_movie_id,UpdateHelperVars.return_book_id,UpdateHelperVars.return_season_id), :content_type => "application/json"
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
    @data['releaseId'].match(/^[0-9a-f]{24}$/).should be_true
    UpdateHelperVars.set_release_id @data['releaseId']
  end
  
end

################################## SECOND SET: UPDATES ################################## 

describe "V3 Object API -- Update Game", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{UpdateHelperVars.return_game_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_game_body(UpdateHelperVars.return_object_slug('game',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a gameId key" do
    @data.has_key?('gameId').should be_true  
  end
  
  it "should return the correct gameId value" do
    @data['gameId'].should == UpdateHelperVars.return_game_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Company", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies/#{UpdateHelperVars.return_company_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_company_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('company',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a companyId key" do
    @data.has_key?('companyId').should be_true  
  end
  
  it "should return the correct companyId value" do
    @data['companyId'].should == UpdateHelperVars.return_company_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Feature", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features/#{UpdateHelperVars.return_feature_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_feature_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('feature',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a featureId key" do
    @data.has_key?('featureId').should be_true  
  end
  
  it "should return the correct featureId value" do
    @data['featureId'].should == UpdateHelperVars.return_feature_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Genre", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres/#{UpdateHelperVars.return_genre_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_genre_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('genre',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true  
  end
  
  it "should return the correct genreId value" do
    @data['genreId'].should == UpdateHelperVars.return_genre_id
  end

end

####################################################################

describe "V3 Object API -- Update Second Genre", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres/#{UpdateHelperVars.return_genre2_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_genre_body(UpdateHelperVars.return_number_2,UpdateHelperVars.return_object_slug('genre',UpdateHelperVars.return_number_2)), :content_type => "application/json"
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

  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true
  end

  it "should return the correct genreId value" do
    @data['genreId'].should == UpdateHelperVars.return_genre2_id
  end

end

#################################################################### 

describe "V3 Object API -- Update Hardware", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware/#{UpdateHelperVars.return_hardware_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_hardware_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('hardware',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  
  it "should return a hardwareId key" do
    @data.has_key?('hardwareId').should be_true  
  end
  
  it "should return the correct hardwareId value" do
    @data['hardwareId'].should == UpdateHelperVars.return_hardware_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Market", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets/#{UpdateHelperVars.return_market_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_market_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('market',UpdateHelperVars.return_number)), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s.to_s)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  it "should return 200" do  
  end
  
  it "should return a marketId key" do
    @data.has_key?('marketId').should be_true  
  end
  
  it "should return the correct marketId value" do
    @data['marketId'].should == UpdateHelperVars.return_market_id
  end

end

####################################################################

describe "V3 Object API -- Update Movie", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{UpdateHelperVars.return_movie_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_movie_body(UpdateHelperVars.return_object_slug('movie',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a movieId key" do
    @data.has_key?('movieId').should be_true
  end

  it "should return the correct movieId value" do
    @data['movieId'].should == UpdateHelperVars.return_movie_id
  end

end

####################################################################

describe "V3 Object API -- Update Volume", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/#{UpdateHelperVars.return_volume_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_volume_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('volume',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a volumeId key" do
    @data.has_key?('volumeId').should be_true
  end

  it "should return the correct volumeId value" do
    @data['volumeId'].should == UpdateHelperVars.return_volume_id
  end

end

####################################################################

describe "V3 Object API -- Update Book", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/#{UpdateHelperVars.return_book_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      vol1 = JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/slug/100-bullets").body)['volumeId']
      vol2 = JSON.parse(RestClient.get("http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/slug/batman-the-return").body)['volumeId']
      @response = RestClient.put @url, update_book_body(UpdateHelperVars.return_object_slug('book',UpdateHelperVars.return_number), vol1, vol2), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return a bookId key" do
    @data.has_key?('bookId').should be_true
  end

  it "should return the correct bookId value" do
    @data['bookId'].should == UpdateHelperVars.return_book_id
  end

end

####################################################################

describe "V3 Object API -- Update Person", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{UpdateHelperVars.return_person_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_person_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('person',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a personId key" do
    @data.has_key?('personId').should be_true
  end

  it "should return the correct personId value" do
    @data['personId'].should == UpdateHelperVars.return_person_id
  end

end

####################################################################

describe "V3 Object API -- Update Character", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{UpdateHelperVars.return_character_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_character_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('character',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a characterId key" do
    @data.has_key?('characterId').should be_true
  end

  it "should return the correct characterId value" do
    @data['characterId'].should == UpdateHelperVars.return_character_id
  end

end

####################################################################

describe "V3 Object API -- Update RoleType", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes/#{UpdateHelperVars.return_roletype_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_roletype_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('roletype',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a roleTypeId key" do
    @data.has_key?('roleTypeId').should be_true
  end

  it "should return the correct roleTypeId value" do
    @data['roleTypeId'].should == UpdateHelperVars.return_roletype_id
  end

end

####################################################################
#Skip Update Season to test third level nested of show in release

####################################################################

describe "V3 Object API -- Update Show", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows/#{UpdateHelperVars.return_show_id}?oauth_token=#{UpdateHelperVars.return_token}"
    begin
      @response = RestClient.put @url, update_show_body(UpdateHelperVars.return_number,UpdateHelperVars.return_object_slug('show',UpdateHelperVars.return_number)), :content_type => "application/json"
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
  end

  it "should return a showId key" do
    @data.has_key?('showId').should be_true
  end

  it "should return the correct showId value" do
    @data['showId'].should == UpdateHelperVars.return_show_id
  end

end

################################## THIRD SET: CHECK UPDATES ##################################

describe "V3 Object API -- Check Nested Updates Reflect in Episode", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/episodes/#{UpdateHelperVars.return_episode_id}"
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

  %w(slug name shortDescription ).each do |field|
    it "should return the updated metadata.show.metadata.#{field} value" do
      @data['metadata']['show']['metadata'][field].match(/updated/).should be_true
    end
  end

  {:description=>"description",:alternateNames=>["alt name one","two"],:commonName=>"common name",:misspelledNames=>['misspelled one','two']}.each do |field,value|
    it "should return the added metadata.show.metadata.#{field} value" do
      @data['metadata']['show']['metadata'][field.to_s].should == value
    end
  end

  %w(slug name shortDescription ).each do |field|
    it "should return the updated metadata.season.metadata.show.metadata.#{field} value" do
      @data['metadata']['season']['metadata']['show']['metadata'][field].match(/updated/).should be_true
    end
  end

  {:description=>"description",:alternateNames=>["alt name one","two"],:commonName=>"common name",:misspelledNames=>['misspelled one','two']}.each do |field,value|
    it "should return the added metadata.season.metadata.show.metadata.#{field} value" do
      @data['metadata']['season']['metadata']['show']['metadata'][field.to_s].should == value
    end
  end

end

describe "V3 Object API -- Check Nested Updates Reflect in Book", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/#{UpdateHelperVars.return_book_id}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
    @book_data = @data['metadata']['volume']['metadata']

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return the updated metadata.volume.metadata.name value" do
    @book_data['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.volume.metadata.slug value" do
    @book_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.volume.metadata.description value" do
    @book_data['description'].should == "qa volume description"
  end

  it "should return the updated metadata.volume.metadata.type value" do
    @book_data['type'].should == "comic"
  end

  it "should return the updated metadata.volume.metadata.commonName value" do
    @book_data['commonName'].should == 'qa common name'
  end

  it "should return the updated metadata.volume.metadata.misspelledNames value" do
    @book_data['misspelledNames'].should == ['misspelled one updated','misspelled two updated','misspelled three updated']
  end

  it "should return the updated metadata.additionalVolumes values" do
    @data['metadata']['additionalVolumes'][0]['metadata']['slug'].should == '100-bullets'
    @data['metadata']['additionalVolumes'][1]['metadata']['slug'].should == 'batman-the-return'
  end

end

####################################################################

describe "V3 Object API -- Check Nested Updates Reflect in Role", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{UpdateHelperVars.return_role_id}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

    @movie_data = @data['metadata']['movie']['metadata']
    @character_data = @data['metadata']['character']['metadata']
    @roletype_data = @data['metadata']['roleType']['metadata']
    @game_data = @data['metadata']['game']['metadata']
    @book_data = @data['metadata']['book']['metadata']
    @person_data = @data['metadata']['person']['metadata']

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return the updated metadata.movie.metadata.slug value" do
    @movie_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.movie.metadata.type value" do
    @movie_data['type'].should == 'on-demand'
  end

  it "should return the updated metadata.character.metadata.slug value" do
    @character_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.character.metadata.name value" do
    @character_data['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.character.metadata.alternateNames value" do
    @character_data['alternateNames'].should == ["alt name one updated", "alt name two"]
  end

  it "should return the updated metadata.character.metadata.firstAppearance value" do
    @character_data['firstAppearance'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.character.metadata.description value" do
    @character_data['description'].should == "character description"
  end

  it "should return the updated metadata.roleType.metadata.slug value" do
    @roletype_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.roleType.metadata.name value" do
    @roletype_data['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.game.metadata.slug value" do
    @game_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.book.metadata.slug value" do
    @book_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.person.metadata.slug value" do
    @person_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.person.metadata.name value" do
    @person_data['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.person.metadata.misspelledNames value" do
    @person_data['misspelledNames'].should == ["misspelled name one updated", "misspelled name two"]
  end

  it "should return the updated metadata.person.metadata.description value" do
    @person_data['description'].should == "person description updated"
  end

end

####################################################################

describe "V3 Object API -- Check Nested Updates Reflect in Release", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases/#{UpdateHelperVars.return_release_id}"
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
  
  it "should return the correct metadata.game.gameId value" do
    @data['metadata']['game']['gameId'].should == UpdateHelperVars.return_game_id  
  end
  
  it "should return metadata.game.metadata.slug with the updated value" do
    @data['metadata']['game']['metadata']['slug'].match(/updated/).should be_true 
  end
  
  it "should return the correct metadata.movie.movieId value" do
    @data['metadata']['movie']['movieId'].should == UpdateHelperVars.return_movie_id
  end

  it "should return metadata.movie.metadata.slug with the updated value" do
    @data['metadata']['movie']['metadata']['slug'].match(/updated/).should be_true
  end

  it "should return metadata.movie.metadata.type with the updated value" do
    @data['metadata']['movie']['metadata']['type'].match(/on-demand/).should be_true
  end

  it "should return the updated metadata.book.metadata.slug value" do
    @data['metadata']['book']['metadata']['slug'].to_s.match(/updated/).should be_true
  end


  it "should return the updated metadata.book.metadata.additionalVolumes values" do
    @data['metadata']['book']['metadata']['additionalVolumes'][0]['metadata']['slug'].should == '100-bullets'
    @data['metadata']['book']['metadata']['additionalVolumes'][1]['metadata']['slug'].should == 'batman-the-return'
  end

  it "should return the updated metadata.book.metadata.volume.metadata.name value" do
    @data['metadata']['book']['metadata']['volume']['metadata']['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.book.metadata.volume.metadata.slug value" do
    @data['metadata']['book']['metadata']['volume']['metadata']['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.book.metadata.volume.metadata.description value" do
    @data['metadata']['book']['metadata']['volume']['metadata']['description'].should == 'qa volume description'
  end

  it "should return the updated metadata.book.metadata.volume.metadata.type value" do
    @data['metadata']['book']['metadata']['volume']['metadata']['type'].should == 'comic'
  end

  it "should return the updated metadata.book.metadata.volume.metadata.commonName value" do
    @data['metadata']['book']['metadata']['volume']['metadata']['commonName'].should == 'qa common name'
  end

  it "should return the updated metadata.book.metadata.volume.metadata.name misspelledNames" do
    @data['metadata']['book']['metadata']['volume']['metadata']['misspelledNames'].should == ['misspelled one updated','misspelled two updated','misspelled three updated']
  end

  it "should return the metadata.season.metadata.show.metadata.name value" do
    @data['metadata']['season']['metadata']['show']['metadata']['name'].to_s.match(/updated/).should be_true
  end

  it "should return the metadata.season.metadata.show.metadata.slug value" do
    @data['metadata']['season']['metadata']['show']['metadata']['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.season.metadata.show.metadata.shortDescription value" do
    @data['metadata']['season']['metadata']['show']['metadata']['shortDescription'].should == "short description updated"
  end

  it "should return the updated metadata.season.metadata.show.metadata.description value" do
    @data['metadata']['season']['metadata']['show']['metadata']['description'].should == "description"
  end

  it "should return the updated metadata.season.metadata.show.metadata.alternateNames value" do
    @data['metadata']['season']['metadata']['show']['metadata']['alternateNames'].should == ["alt name one","two"]
  end

  it "should return the updated metadata.season.metadata.show.metadata.misspelledNames value" do
    @data['metadata']['season']['metadata']['show']['metadata']['misspelledNames'].should == ['misspelled one','two']
  end
  
  %w(publishers developers distributors producers effects).each do |co_type|

    it "should return the correct companies.#{co_type}.companyId value" do
      @data['companies'][co_type][0]['companyId'].should == UpdateHelperVars.return_company_id
    end

    ['slug','name','alternateNames','commonName',"description"].each do |field|
      it "should return companies.#{co_type}.metadata.#{field} with the updated value" do
        @data['companies'][co_type][0]['metadata'][field].to_s.match(/updated/).should be_true
      end
    end
  end
  
  it "should return the correct content.supports.featureId value" do
    @data['content']['supports'][0]['featureId'].should == UpdateHelperVars.return_feature_id
  end
  
  ['name','description','slug','valueOneLabel'].each do |field|
    it "should return content.supports.metadata.#{field} with the updated value" do
      @data['content']['supports'][0]['metadata'][field].to_s.match(/updated/).should be_true
    end  
  end
  
  it "should return content.supports.metadata.valueTwoLabel with the added value" do
    @data['content']['supports'][0]['metadata']['valueTwoLabel'].to_s.match(/added/).should be_true
  end


  it "should return the correct content.primaryGenre.genreId value" do
    @data['content']['primaryGenre']['genreId'].should == UpdateHelperVars.return_genre_id
  end

  it "should return the correct content.additionalGenres.genreId value for each additional genre" do
    @data['content']['additionalGenres'][0]['genreId'].should == UpdateHelperVars.return_genre_id
    @data['content']['additionalGenres'][1]['genreId'].should == UpdateHelperVars.return_genre2_id
  end

  %w(name description slug).each do |field|
    it "should return content.primaryGenre.metadata.#{field} with the updated value" do
      @data['content']['primaryGenre']['metadata'][field].to_s.match(/updated/).should be_true
    end
  end

  %w(name description slug).each do |field|
    it "should return content.additionalGenres.metadata.#{field} with the updated value for the first genre" do
    @data['content']['additionalGenres'][0]['metadata'].to_s.match(/updated/).should be_true
    end
  end

  it "should return content.additionalGenres.metadata.slug,description,name with the updated value for each additional genre" do
    %w(slug description name).each do |field|
      @data['content']['additionalGenres'].each do |genre|
        genre['metadata'][field].match(/updated/).should be_true
      end
    end
  end
  
  it "should return the correct hardware.platform.hardwareId value" do
    @data['hardware']['platform']['hardwareId'].should == UpdateHelperVars.return_hardware_id
  end
  
  ['name','description','slug'].each do |field|
    it "should return hardware.platform.metadata.#{field} with the updated value" do
      @data['hardware']['platform']['metadata'][field].to_s.match(/updated/).should be_true
    end
  end
  
  it "should return hardware.platform.metadata.type with the added value" do
    @data['hardware']['platform']['metadata']['type'].should == 'console'
  end
  
  it "should return hardware.platform.releaseDate.date with the updated value" do
    @data['hardware']['platform']['metadata']['releaseDate']['date'].should == '2011-12-12'
  end
  
  it "should return hardware.platform.releaseDate.display with the updated value" do
    @data['hardware']['platform']['metadata']['releaseDate']['display'].should == 'Q4 2011'
  end
  
  it "should return hardware.platform.releaseDate.status with the updated value" do
    @data['hardware']['platform']['metadata']['releaseDate']['status'].should == "released"
  end
  
  it "should return the correct purchasing.buy.marketId value" do
    @data['purchasing']['buy'][0]['marketId'].should == UpdateHelperVars.return_market_id
  end

  ['name','description','slug'].each do |field|
    it "should return purchasing.buy.metadata.#{field} with the updated value" do
      @data['purchasing']['buy'][0]['metadata'][field].to_s.match(/updated/).should be_true
    end  
  end

end

####################################################################

describe "V3 Object API -- Check Nested Updates Reflect in Season", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons/#{UpdateHelperVars.return_season_id}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

    @season_data = @data['metadata']['show']['metadata']

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return the updated metadata.volume.metadata.name value" do
    @season_data['name'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.volume.metadata.slug value" do
    @season_data['slug'].to_s.match(/updated/).should be_true
  end

  it "should return the updated metadata.volume.metadata.shortDescription value" do
    @season_data['shortDescription'].should == "short description updated"
  end

  it "should return the updated metadata.volume.metadata.description value" do
    @season_data['description'].should == "description"
  end

  it "should return the updated metadata.volume.metadata.alternateNames value" do
    @season_data['alternateNames'].should == ["alt name one","two"]
  end

  it "should return the updated metadata.volume.metadata.misspelledNames value" do
    @season_data['misspelledNames'].should == ['misspelled one','two']
  end

end


################################## CLEAN UP: DELETE OBJECTS ##################################

describe "V3 Object API -- Clean Up: Delete Objects", :stg => true do

  obj = %w(games companies features genres genres hardware markets releases movies books volumes people characters roleTypes roles shows seasons episodes)
  obj.each_index do |val|
  it "should return a 404 after deleting #{obj[val]} object" do

    case val
      when 0
        id = UpdateHelperVars.return_game_id
      when 1
        id = UpdateHelperVars.return_company_id
      when 2
        id =  UpdateHelperVars.return_feature_id
      when 3
        id = UpdateHelperVars.return_genre_id
      when 4
        id = UpdateHelperVars.return_genre2_id
      when 5
        id = UpdateHelperVars.return_hardware_id
      when 6
        id = UpdateHelperVars.return_market_id
      when 7
        id = UpdateHelperVars.return_release_id
      when 8
        id = UpdateHelperVars.return_movie_id
      when 9
        id = UpdateHelperVars.return_book_id
      when 10
        id = UpdateHelperVars.return_volume_id
      when 11
        id = UpdateHelperVars.return_person_id
      when 12
        id =  UpdateHelperVars.return_character_id
      when 13
        id =  UpdateHelperVars.return_roletype_id
      when 14
        id = UpdateHelperVars.return_role_id
      when 15
        id = UpdateHelperVars.return_show_id
      when 16
        id = UpdateHelperVars.return_season_id
      when 17
        id = UpdateHelperVars.return_episode_id
      else
        id = ""
    end

  del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/#{obj[val]}/#{id}?oauth_token=#{UpdateHelperVars.return_token}"
  begin
    @response = RestClient.delete del_url
  rescue => e
    raise Exception.new(e.message+" "+del_url)
  end

  sleep 0.35

  expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/#{obj[val]}/#{id}"}.to raise_error(RestClient::ResourceNotFound)

  end 
  end
end