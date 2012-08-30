require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'object_api_helper'

include Assert
include ObjectApiHelper

class ObjectIds
  
  @me3_release_ids = get_release_ids_by_legacy_id('110694')
  @me3_game_id = get_game_id('mass-effect-3')
  @me3_uk_release_id = get_me3_uk_id
  @bioware_company_id = get_company_id('bioware')
  @high_def_feature_id = get_feature_id('1080p')
  @action_genre_id = get_genre_id('action')
  @xbox_hardware_id = get_hardware_id('xbox-360')
  @movie_id = get_movie_id('the-dark-knight')
  @book_id = get_book_id('batman-the-dark-knight-2011-11')
  @volume_id = get_volume_id('batman-the-dark-knight-2011')
  @person_id = get_person_id('christian-bale')
  @character_id = get_character_id('batman')
  @role_id = get_role_id(940319)
  @roletype_id = get_roletype_id('actor')
  @show_id = get_show_id('batman-the-animated-series')
  @season_id = get_season_id('batman-the-animated-series-season-1')
  @episode_id = get_episode_id('dreams-in-darkness')
  
  def self.me3_release_ids
    @me3_release_ids
  end
  
  def self.me3_game_id
    @me3_game_id
  end
  
  def self.me3_uk_release_id
    @me3_uk_release_id
  end
  
  def self.bioware_id
    @bioware_company_id
  end
  
  def self.high_def_id
    @high_def_feature_id
  end
  
  def self.action_id
    @action_genre_id
  end
  
  def self.xbox_id
    @xbox_hardware_id
  end

  def self.movie_id
    @movie_id
  end

  def self.book_id
    @book_id
  end

  def self.volume_id
    @volume_id
  end

  def self.person_id
    @person_id
  end

  def self.character_id
    @character_id
  end

  def self.role_id
    @role_id
  end

  def self.roletype_id
    @roletype_id
  end

  def self.show_id
    @show_id
  end

  def self.season_id
    @season_id
  end

  def self.episode_id
    @episode_id
  end

end

describe "V3 Object API -- Releases Smoke Tests -- /ping" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/ping"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    check_200(@response)
  end


  it "should return a response of 'pong\/n'" do
    @data.should == "pong\n"
  end

end

describe "V3 Object API -- Releases Smoke Tests -- /releases?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with five indices" do
    check_indices(@data, 5)
  end
  
  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end
  
  it "should return 200 releases" do
    @data['data'].length.should == 200
  end
  
  ['releaseId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, not-blank value for all releases" do
      @data['data'].each do |release|
        begin
          release.has_key?(data).should be_true
        rescue => e
          raise Exception.new("#{e.message} on #{release['releaseId']}")
        end#end Exception
        release[data].should_not be_nil
        release[data].to_s.length.should > 0
      end
    end
  end
  
  #releaseId assertions
  
  it "should return a releaseId value that is a 24-character hash for all releases" do
    @data['data'].each do |release|
      release['releaseId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  # metadata assertions
=begin
  ['releaseDate','name','state','released','description','commonName','shortDescription','region','legacyId','game'].each do |data|
    it "should return metadata.#{data} data with a non-nil, not-blank value for all releases" do
      @data['data'].each do |data|
        data['metadata'].has_key?(data).should be_true
        data['metadata'][data].should_not be_nil
        data['metadata'][data].to_s.length.should > 0
      end
    end
  end
=end

  it "should return metadata.name data with a non-nil, non-blank value for all releases" do
    
  end

  # content assertions
  
  # hardware assertions
  
  # system assertoins
  
end

###################################################

describe "V3 Object API -- Releases Smoke Tests -- /releases/legacyId/110694" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/legacyId/110694"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return four releases" do
    @data['data'].length.should == 4
  end
  
  it "should return four releases with a metadata.legacyId value of 110694" do
    @data['data'].each do |release|
      release['metadata']['legacyId'].should == 110694
    end
  end
  
  it "shoud return four specific releaseId values for each four releases" do
    ids = ObjectIds.me3_release_ids
    @data['data'].each do |release|
      ids.include?release['releaseId'].should be_true
    end
  end
  
  it "should only return releases with a metadata.game.gameId value of #{ObjectIds.me3_game_id}" do
    @data['data'].each do |release|
      release['metadata']['game']['gameId'].should == ObjectIds.me3_game_id
    end
  end
  
  it "should only return releases with a metadata.game.metadata.slug value of mass-effect-3" do
    @data['data'].each do |release|
      release['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
    end
  end
  
end

###################################################

describe "V3 Object API -- Releases Smoke Tests -- /releases/#{ObjectIds.me3_uk_release_id}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/#{ObjectIds.me3_uk_release_id}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['releaseId','metadata','content','hardware','system'].each do |data|
    it "shoud return a release with a non-nil, non-blank #{data} data" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end
  
  it "should return a release with a releaseId value of #{ObjectIds.me3_uk_release_id}" do
    @data['releaseId'].should == ObjectIds.me3_uk_release_id
  end
  
  it "shoud return a release with a metadata.region value of UK" do
    @data['metadata'].has_key?('region').should be_true
    @data['metadata']['region'].should == 'UK'
  end
  
  it "should only return releases with a metadata.game.gameId value of #{ObjectIds.me3_game_id}" do
    @data['metadata']['game']['gameId'].should == ObjectIds.me3_game_id
  end
  
  it "should only return releases with a metadata.game.metadata.slug value of mass-effect-3" do
    @data['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
  end
  
end

###################################################

describe "V3 Object API -- Games Smoke Tests -- /games?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/games?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return 200 games" do
    @data['data'].length.should == 200
  end
  
  it "should return at least 20 games" do
    @data['data'].length.should > 19
  end
  
  ['gameId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all games" do
      @data['data'].each do |game|
        game.has_key?(data).should be_true
        game[data].should_not be_nil
        game[data].to_s.length.should > 0
      end
    end
  end
  
  it "should return a gameId value that is a 24-character hash for all games" do
    @data['data'].each do |game|
      game['gameId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  it "should return metadata.slug data with a non-nil, non-blank value for all games" do
    @data['data'].each do |game|
      game['metadata'].has_key?('slug').should be_true
      game['metadata']['slug'].should_not be_nil
      game['metadata']['slug'].to_s.length.should > 0
    end
  end
  
  it "should return system.createdAt data with a non-nil, non-blank value for all games" do
    @data['data'].each do |game|
      game['system'].has_key?('createdAt').should be_true
      game['system']['createdAt'].should_not be_nil
      game['system']['createdAt'].to_s.length.should > 0
    end  
  end
  
  it "should return system.updatedAt data with a non-nil, non-blank value for all games" do
    @data['data'].each do |game|
      game['system'].has_key?('updatedAt').should be_true
      game['system']['updatedAt'].should_not be_nil
      game['system']['updatedAt'].to_s.length.should > 0
    end  
  end
  
end

###################################################

["/#{ObjectIds.me3_game_id}","/slug/mass-effect-3"].each do |call|
describe "V3 Object API -- Games Smoke Tests -- /games#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/games#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should a release with a gameId value of #{ObjectIds.me3_game_id}" do
    @data.has_key?('gameId').should be_true
    @data['gameId'].should == ObjectIds.me3_game_id
  end
  
  it "should a release with a metadata.slug value of mass-effect-3" do
    @data.has_key?('metadata').should be_true
    @data['metadata'].has_key?('slug').should be_true
    @data['metadata']['slug'].should == 'mass-effect-3'  
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should retrun a release with non-blank, non-nil system.#{data} data" do
      @data.has_key?('system').should be_true
      @data['system'].has_key?(data).should be_true
      @data['system'][data].should_not be_nil
      @data['system'][data].to_s.length.should > 0
    end
  end

end
end

###################################################

describe "V3 Object API -- Companies Smoke Tests -- /companies?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/companies?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return 200 companies" do
    @data['data'].length.should == 200
  end
  
  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end
  
  ['companyId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all companies" do
      @data['data'].each do |company|
        company.has_key?(data).should be_true
        company[data].should_not be_nil
        company[data].to_s.length.should > 0
      end
    end  
  end
  
  it "should return a companyId value that is a 24-character hash for all companies" do
    @data['data'].each do |company|
      company['companyId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  it "should return metadata.name with a non-nil, non-blank value for all companies" do
    @data['data'].each do |company|
      company['metadata'].has_key?('name').should be_true
      company['metadata']['name'].should_not be_nil
      company['metadata']['name'].to_s.length.should > 0
    end
  end
  
  it "should retrn metadata.slug with a non-nil, non-blank value for all companies" do
    @data['data'].each do |company|
      company['metadata'].has_key?('slug').should be_true
      company['metadata']['slug'].should_not be_nil
      company['metadata']['slug'].to_s.length.should > 0
    end
  end
  
  it "should retrn metadata.legacyId with a non-nil, non-blank value for all companies" do
    @data['data'].each do |company|
      company['metadata'].has_key?('legacyId').should be_true
      company['metadata']['legacyId'].should_not be_nil
      company['metadata']['legacyId'].to_s.length.should > 0
    end
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return system.#{data} with a non-nil, non-blank value for all companies" do
      @data['data'].each do |company|
        company['system'].has_key?(data).should be_true
        company['system'][data].should_not be_nil
        company['system'][data].to_s.length.should > 0
      end
    end
  end
  
end

###################################################

describe "V3 Object API -- Companies Smoke Tests -- /companies?query=art&count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/companies?query=art&count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end
  
  it "should return at least 20 companies" do
    @data['data'].length.should > 19
  end
  
  it "should return only companies with metadata.name values that match the regex /art/" do
    @data['data'].each do |company|
      company.has_key?('metadata').should be_true
      company['metadata'].has_key?('name').should be_true
      begin
        company['metadata']['name'].match(/art/i).should be_true
      rescue => e
        error = company
        raise Exception.new(error.to_s)
      end#end Exception
    end
  end
  
end

###################################################

["/#{ObjectIds.bioware_id}","/slug/bioware"].each do |call|
describe "V3 Object API -- Companies Smoke Tests -- /companies#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/companies#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a company with a companyId value of #{ObjectIds.bioware_id}" do
    @data.has_key?('companyId').should be_true
    @data['companyId'].should == ObjectIds.bioware_id
  end
  
  it "should return a company with a metadata.slug value of 'bioware'" do
    @data.has_key?('metadata').should be_true
    @data['metadata'].has_key?('slug').should be_true
    @data['metadata']['slug'].should == 'bioware'
  end
  
  it "should return a company with a non-nil, non-blank metadata.legacyId value" do
    @data['metadata'].has_key?('legacyId').should be_true
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.length.should > 0
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return a company with non-nil, non-blank system.#{data} data" do
      @data['system'].has_key?(data).should be_true
      @data['system'][data].should_not be_nil
      @data['system'][data].to_s.length.should > 0
    end
  end
  
end
end

###################################################

describe "V3 Object API -- Features Smoke Tests -- /features?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/features?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end
  
  it "should return at least 20 features" do
    @data['data'].length.should > 19
  end
  
  ['featureId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all features" do
      @data['data'].each do |feature|
        feature.has_key?(data).should be_true
        feature[data].should_not be_nil
        feature[data].to_s.length.should > 0
      end
    end
  end
  
  it "should return a featureId value that is a 24-character hash for all features" do
    @data['data'].each do |feature|
      feature['featureId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  it "should return metadata.slug data with a non-nil, non-blank value for all features" do
    @data['data'].each do |feature|
      feature['metadata'].has_key?('slug').should be_true
      feature['metadata']['slug'].should_not be_nil
      feature['metadata']['slug'].to_s.length.should > 0
    end
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all features" do
      @data['data'].each do |feature|
        feature['system'].has_key?(data).should be_true
        feature['system'][data].should_not be_nil
        feature['system'][data].to_s.length.should > 0
      end  
    end
  end
  
end

###################################################

["/#{ObjectIds.high_def_id}","/slug/1080p"].each do |call|
describe "V3 Object API -- Features Smoke Tests -- /features#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/features#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a feature with a featureId value of #{ObjectIds.high_def_id}" do
    @data.has_key?('featureId').should be_true
    @data['featureId'].should == ObjectIds.high_def_id
  end
  
  it "should return a feature with a metadata.slug value of '1080p'" do
    @data.has_key?('metadata').should be_true
    @data['metadata'].has_key?('slug').should be_true
    @data['metadata']['slug'].should == '1080p'
  end
  
  it "should return a feature with a non-nil, non-blank metadata.legacyId value" do
    @data['metadata'].has_key?('legacyId').should be_true
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.length.should > 0
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return a feature with non-nil, non-blank system.#{data} data" do
      @data['system'].has_key?(data).should be_true
      @data['system'][data].should_not be_nil
      @data['system'][data].to_s.length.should > 0
    end
  end
  
end
end

###################################################

describe "V3 Object API -- Genre Smoke Tests -- /genres?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/genres?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end
  
  it "should return at least 20 genres" do
    @data['data'].length.should > 19
  end
  
  ['genreId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all genres" do
      @data['data'].each do |genre|
        genre.has_key?(data).should be_true
        genre[data].should_not be_nil
        genre[data].to_s.length.should > 0
      end
    end
  end
  
  it "should return a genreId value that is a 24-character hash for all genres" do
    @data['data'].each do |genre|
      genre['genreId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  it "should return metadata.slug data with a non-nil, non-blank value for all genres" do
    @data['data'].each do |genre|
      genre['metadata'].has_key?('slug').should be_true
      genre['metadata']['slug'].should_not be_nil
      genre['metadata']['slug'].to_s.length.should > 0
    end
  end

  it "should return metadata.type data with a non-nil, non-blank value for all genres" do
    @data['data'].each do |genre|
      genre['metadata'].has_key?('type').should be_true
      genre['metadata']['type'].should_not be_nil
      genre['metadata']['type'].to_s.length.should > 0
    end
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all genres" do
      @data['data'].each do |genre|
        genre['system'].has_key?(data).should be_true
        genre['system'][data].should_not be_nil
        genre['system'][data].to_s.length.should > 0
      end  
    end
  end
  
end


###################################################

["/#{ObjectIds.action_id}","/slug/action"].each do |call|
describe "V3 Object API -- Genre Smoke Tests -- /genres#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/genres#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a genre with a genreId value of #{ObjectIds.action_id}" do
    @data.has_key?('genreId').should be_true
    @data['genreId'].should == ObjectIds.action_id
  end
  
  it "should return a genre with a metadata.slug value of 'action'" do
    @data.has_key?('metadata').should be_true
    @data['metadata'].has_key?('slug').should be_true
    @data['metadata']['slug'].should == 'action'
  end
  
  it "should return a genre with a non-nil, non-blank metadata.legacyId value" do
    @data['metadata'].has_key?('legacyId').should be_true
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.length.should > 0
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return a feature with non-nil, non-blank system.#{data} data" do
      @data['system'].has_key?(data).should be_true
      @data['system'][data].should_not be_nil
      @data['system'][data].to_s.length.should > 0
    end
  end
  
end
end

###################################################

describe "V3 Object API -- Hardware Smoke Tests -- /hardware?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/hardware?count=200"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end
  
  it "should return at least 20 hardwares" do
    @data['data'].length.should > 19
  end
  
  ['hardwareId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all hardwares" do
      @data['data'].each do |hardware|
        hardware.has_key?(data).should be_true
        hardware[data].should_not be_nil
        hardware[data].to_s.length.should > 0
      end
    end
  end
  
  it "should return a hardwareId value that is a 24-character hash for all hardwares" do
    @data['data'].each do |hardware|
      hardware['hardwareId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end
  
  it "should return metadata.slug data with a non-nil, non-blank value for all hardwares" do
    @data['data'].each do |hardware|
      hardware['metadata'].has_key?('slug').should be_true
      hardware['metadata']['slug'].should_not be_nil
      hardware['metadata']['slug'].to_s.length.should > 0
    end
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all hardwares" do
      @data['data'].each do |hardware|
        hardware['system'].has_key?(data).should be_true
        hardware['system'][data].should_not be_nil
        hardware['system'][data].to_s.length.should > 0
      end  
    end
  end
  
end

###################################################

["/#{ObjectIds.xbox_id}","/slug/xbox-360"].each do |call|
describe "V3 Object API -- Hardware Smoke Tests -- /hardware#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/hardware#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hardware with a hardwareId value of #{ObjectIds.xbox_id}" do
    @data.has_key?('hardwareId').should be_true
    @data['hardwareId'].should == ObjectIds.xbox_id
  end
  
  it "should return a hardware with a metadata.slug value of 'xbox-360'" do
    @data.has_key?('metadata').should be_true
    @data['metadata'].has_key?('slug').should be_true
    @data['metadata']['slug'].should == 'xbox-360'
  end
  
  it "should return a hardware with a non-nil, non-blank metadata.legacyId value" do
    @data['metadata'].has_key?('legacyId').should be_true
    @data['metadata']['legacyId'].should_not be_nil
    @data['metadata']['legacyId'].to_s.length.should > 0
  end
  
  ['createdAt','updatedAt'].each do |data|
    it "should return a hardware with non-nil, non-blank system.#{data} data" do
      @data['system'].has_key?(data).should be_true
      @data['system'][data].should_not be_nil
      @data['system'][data].to_s.length.should > 0
    end
  end
  
end
end

###################################################

describe "V3 Object API -- Movies Smoke Tests -- /movies?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/movies?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['movieId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all movies" do
      @data['data'].each do |movie|
        movie.has_key?(data).should be_true
        movie[data].should_not be_nil
        movie[data].to_s.length.should > 0
      end
    end
  end

  it "should return a movieId value that is a 24-character hash for all movies" do
    @data['data'].each do |movie|
      movie['movieId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(slug type).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all movies" do
      @data['data'].each do |movie|
        movie['metadata'].has_key?(data).should be_true
        movie['metadata'][data].should_not be_nil
        movie['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all movies" do
      @data['data'].each do |movie|
        movie['system'].has_key?(data).should be_true
        movie['system'][data].should_not be_nil
        movie['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.movie_id}","/slug/the-dark-knight"].each do |call|
  describe "V3 Object API -- Movies Smoke Tests -- /movies#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/movies#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a movie with a movieId value of #{ObjectIds.movie_id}" do
      @data.has_key?('movieId').should be_true
      @data['movieId'].should == ObjectIds.movie_id
    end

    it "should return a movie with a metadata.slug value of 'the-dark-knight'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'the-dark-knight'
    end

    it "should return metadata.type data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('type').should be_true
      @data['metadata']['type'].should_not be_nil
      @data['metadata']['type'].to_s.length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Books Smoke Tests -- /books?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/books?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['bookId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all books" do
      @data['data'].each do |book|
        book.has_key?(data).should be_true
        book[data].should_not be_nil
        book[data].to_s.length.should > 0
      end
    end
  end

  it "should return a bookId value that is a 24-character hash for all books" do
    @data['data'].each do |book|
      book['bookId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all books" do
      @data['data'].each do |book|
        book['metadata'].has_key?(data).should be_true
        book['metadata'][data].should_not be_nil
        book['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all books" do
      @data['data'].each do |book|
        book['system'].has_key?(data).should be_true
        book['system'][data].should_not be_nil
        book['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.book_id}","/slug/batman-the-dark-knight-2011-11"].each do |call|
  describe "V3 Object API -- Books Smoke Tests -- /books#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/books#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a book with a bookId value of #{ObjectIds.book_id}" do
      @data.has_key?('bookId').should be_true
      @data['bookId'].should == ObjectIds.book_id
    end

    it "should return a book with a metadata.slug value of 'batman-the-dark-knight-2011-11'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'batman-the-dark-knight-2011-11'
    end

    it "should return metadata.legacyId data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should_not be_nil
      @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Volumes Smoke Tests -- /volumes?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/volumes?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['volumeId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all volumes" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a volumeId value that is a 24-character hash for all volumes" do
    @data['data'].each do |vol|
      vol['volumeId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name state slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all volumes" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all volumes" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.volume_id}","/slug/batman-the-dark-knight-2011"].each do |call|
  describe "V3 Object API -- Volume Smoke Tests -- /volumes#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/volumes#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a volume with a volumeId value of #{ObjectIds.volume_id}" do
      @data.has_key?('volumeId').should be_true
      @data['volumeId'].should == ObjectIds.volume_id
    end

    it "should return a volume with a metadata.slug value of 'batman-the-dark-knight-2011'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'batman-the-dark-knight-2011'
    end

    it "should return metadata.legacyId data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should_not be_nil
      @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- People Smoke Tests -- /people?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/people?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['personId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all people" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a personId value that is a 24-character hash for all people" do
    @data['data'].each do |vol|
      vol['personId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name state slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all people" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all people" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.person_id}","/slug/christian-bale"].each do |call|
  describe "V3 Object API -- People Smoke Tests -- /people#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/people#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a person with a personId value of #{ObjectIds.person_id}" do
      @data.has_key?('personId').should be_true
      @data['personId'].should == ObjectIds.person_id
    end

    it "should return a person with a metadata.slug value of 'christian-bale'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'christian-bale'
    end

    it "should return metadata.legacyId data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should_not be_nil
      @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Character Smoke Tests -- /characters?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/characters?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['characterId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all characters" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a characterId value that is a 24-character hash for all characters" do
    @data['data'].each do |vol|
      vol['characterId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name state slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all characters" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all characters" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.character_id}","/slug/batman"].each do |call|
  describe "V3 Object API -- Character Smoke Tests -- /characters#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/characters#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a character with a characterId value of #{ObjectIds.character_id}" do
      @data.has_key?('characterId').should be_true
      @data['characterId'].should == ObjectIds.character_id
    end

    it "should return a character with a metadata.slug value of 'batman'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'batman'
    end

    it "should return metadata.legacyId data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should_not be_nil
      @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- RoleType Smoke Tests -- /roleTypes?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/roleTypes?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ['count','startIndex','endIndex','isMore'].each do |data|
    it "should return '#{data}' data with a non-nil, non-blank value" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
    end
  end

  it "should return at least 40 objects" do
    @data['data'].length.should > 39
  end

  ['roleTypeId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all roletypes" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a roleTypeId value that is a 24-character hash for all roletypes" do
    @data['data'].each do |vol|
      vol['roleTypeId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all roletypes" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all roletypes" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.roletype_id}","/slug/actor"].each do |call|
  describe "V3 Object API -- RoleTypes Smoke Tests -- /roleTypes#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/roleTypes#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a character with a roleTypeId value of #{ObjectIds.roletype_id}" do
      @data.has_key?('roleTypeId').should be_true
      @data['roleTypeId'].should == ObjectIds.roletype_id
    end

    it "should return a character with a metadata.slug value of 'actor'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('slug').should be_true
      @data['metadata']['slug'].should == 'actor'
    end

    it "should return metadata.legacyId data with a non-nil, non-blank value" do
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should_not be_nil
      @data['metadata']['legacyId'].to_s.delete('^0-9').length.should > 0
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Role Smoke Tests -- /roles?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/roles?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['roleId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all roles" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a roleId value that is a 24-character hash for all roles" do
    @data['data'].each do |vol|
      vol['roleId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(book movie season character person roleType legacyId).each do |data|
    it "should return metadata.#{data} key for all roles" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(roleType legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all roles" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all roles" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.role_id}","/legacyId/940319"].each do |call|
  describe "V3 Object API -- Role Smoke Tests -- /roles#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/roles#{call}"
      begin
        @response = RestClient.get @url
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
      if call == "/legacyId/940319"
        @data = JSON.parse(@response.body)
        @data = @data['data'][0]
      else
        @data = JSON.parse(@response.body)
      end
    end

    before(:each) do

    end

    after(:each) do

    end

    it "should return 200" do
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a role with a roleId value of #{ObjectIds.role_id}" do
      @data.has_key?('roleId').should be_true
      @data['roleId'].should == ObjectIds.role_id
    end

    it "should return a role with a metadata.legacyId value of '940319'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should == 940319
    end

    it "should return a role with a metadata.lead value of 'true'" do
      @data['metadata'].has_key?('lead').should be_true
      @data['metadata']['lead'].should == true
    end

    %w(movie person roleType).each do |k|
      it "should return a metadata.#{k}.#{k}Id value that is a 24-character hash" do
        @data['metadata'][k][k.to_s+"Id"].match(/^[0-9a-f]{24}$/).should be_true
      end
    end

    {:legacyId=>752133, :slug=>'the-dark-knight', :type=>'theater'}.each do |field,value|
      it "should return a role with a metadata.movie.metadata.#{field} value of '#{value}'" do
        @data['metadata']['movie']['metadata'][field.to_s].should == value
      end
    end

    {:name=>'Christian Bale', :state=>'published', :slug=>'christian-bale', :legacyId=>913820}.each do |field,value|
      it "should return a role with a metadata.person.metadata.#{field} value of '#{value}'" do
        @data['metadata']['person']['metadata'][field.to_s].should == value
      end
    end

    {:name=>'Actor', :legacyId=>14208299, :slug=>'actor'}.each do |field,value|
      it "should return a role with a metadata.roleType.metadata.#{field} value of '#{value}'" do
        @data['metadata']['roleType']['metadata'][field.to_s].should == value
      end
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Shows Smoke Tests -- /shows?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/shows?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['showId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all shows" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a showId value that is a 24-character hash for all shows" do
    @data['data'].each do |vol|
      vol['showId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name state slug legacyId).each do |data|
    it "should return metadata.#{data} key for all shows" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(state slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all roles" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all roles" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.show_id}","/slug/batman-the-animated-series"].each do |call|
  describe "V3 Object API -- Shows Smoke Tests -- /shows#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/shows#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a show with a showId value of #{ObjectIds.show_id}" do
      @data.has_key?('showId').should be_true
      @data['showId'].should == ObjectIds.show_id
    end

    it "should return a show with a metadata.legacyId value of '909538'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should == 909538
    end

    it "should return a show with a metadata.state value of 'published'" do
      @data['metadata'].has_key?('state').should be_true
      @data['metadata']['state'].should == 'published'
    end

    it "should return a show with a metadata.slug value of 'batman-the-animated-series'" do
      @data['metadata']['slug'].should == 'batman-the-animated-series'
    end

    it "should return a show with a metadata.airDate.status value of 'ended'" do
      @data['metadata']['airDate']['status'].should == 'ended'
    end

    it "should return a show with a metadata.name value of 'Batman: The Animated Series'" do
      @data['metadata']['name'].should == 'Batman: The Animated Series'
    end

    {:slug=>'fox',:type=>'tv'}.each do |field,value|
      it "should return a show with a companies.networks.metadata.#{field} value of '#{value}'" do
        @data['companies']['networks'][0]['metadata'][field.to_s].should == value
      end
    end


    {:name=>'Animation',:type=>'tv'}.each do |field,value|
      it "should return a show with a content.primaryGenre.metadata.#{field} value of '#{value}'" do
        @data['content']['primaryGenre']['metadata'][field.to_s].should == value
      end
    end

    it "should return a show with six legacyData.boxArt.url that match 'http'" do
      @data['legacyData']['boxArt'].count.should == 6
      @data['legacyData']['boxArt'].each do |box_art|
        box_art['url'].to_s.match(/http/).should be_true
      end
    end

    it "should return a show with a legacyData.previewUrl of 'http://tv.ign.com/articles/935/935740p1.html'" do
      @data['legacyData']['previewUrl'].should == 'http://tv.ign.com/articles/935/935740p1.html'
    end

    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Seasons Smoke Tests -- /seasons?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/seasons?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['seasonId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all seasons" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a seasonId value that is a 24-character hash for all seasons" do
    @data['data'].each do |vol|
      vol['seasonId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(slug legacyId).each do |data|
    it "should return metadata.#{data} key for all seasons" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(slug legacyId).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all seasons" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all seasons" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.season_id}","/slug/batman-the-animated-series-season-1"].each do |call|
  describe "V3 Object API -- Seasons Smoke Tests -- /seasons#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/seasons#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a season with a seasonId value of #{ObjectIds.season_id}" do
      @data.has_key?('seasonId').should be_true
      @data['seasonId'].should == ObjectIds.season_id
    end

    it "should return a season with a metadata.legacyId value of '909539'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should == 909539
    end


    it "should return a season with a metadata.slug value of 'batman-the-animated-series-season-1'" do
      @data['metadata']['slug'].should == 'batman-the-animated-series-season-1'
    end

    it "should return a season with a metadata.show.metadata.slug value of 'batman-the-animated-series'" do
      @data['metadata'].has_key?('show').should be_true
      @data['metadata']['show']['metadata']['slug'].should == 'batman-the-animated-series'
    end


    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Episodes Smoke Tests -- /episodes?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/episodes?count=200"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>200,'startIndex'=>0,'endIndex'=>199,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return at least 200 objects" do
    @data['data'].length.should == 200
  end

  ['episodeId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a episodeId value that is a 24-character hash for all episodes" do
    @data['data'].each do |vol|
      vol['episodeId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  %w(name legacyId state).each do |data|
    it "should return metadata.#{data} key for all seasons" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(name legacyId state).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

["/#{ObjectIds.episode_id}","/slug/dreams-in-darkness"].each do |call|
  describe "V3 Object API -- Episodes Smoke Tests -- /episodes#{call}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/episodes#{call}"
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
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return an episode with a episodeId value of #{ObjectIds.episode_id}" do
      @data.has_key?('episodeId').should be_true
      @data['episodeId'].should == ObjectIds.episode_id
    end

    it "should return an episode with a metadata.legacyId value of '14236366'" do
      @data.has_key?('metadata').should be_true
      @data['metadata'].has_key?('legacyId').should be_true
      @data['metadata']['legacyId'].should == 14236366
    end

    it "should return an episode with a metadata.state value of 'published'" do
      @data['metadata']['state'].should == 'published'
    end


    it "should return a show with a metadata.slug value of 'dreams-in-darkness'" do
      @data['metadata']['slug'].should == 'dreams-in-darkness'
    end

    it "should return an episode with a metadata.season.metadata.show.metadata.slug value of 'batman-the-animated-series'" do
      @data['metadata'].has_key?('season').should be_true
      @data['metadata']['season']['metadata']['show']['metadata']['slug'].should == 'batman-the-animated-series'
    end


    ['createdAt','updatedAt'].each do |data|
      it "should return a movie with non-nil, non-blank system.#{data} data" do
        @data['system'].has_key?(data).should be_true
        @data['system'][data].should_not be_nil
        @data['system'][data].to_s.length.should > 0
      end
    end

  end
end

###################################################

describe "V3 Object API -- Episodes Smoke Tests -- /episodes/show/#{ObjectIds.show_id}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/episodes/show/#{ObjectIds.show_id}"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>2,'startIndex'=>0,'endIndex'=>1,'isMore'=>false}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return at least one object" do
    @data['data'].length.should > 0
  end

  ['episodeId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a episodeId value that is a 24-character hash for all episodes" do
    @data['data'].each do |vol|
      vol['episodeId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  it "should return metadata.show.showId data with a value of #{ObjectIds.show_id} for all episodes" do
    @data['data'].each do |ep|
      ep['metadata']['show']['showId'].should == ObjectIds.show_id.to_s
    end
  end

  {:state=>'published',:slug=>'batman-the-animated-series',:legacyId=>909538}.each do |field,value|
    it "should return metadata.show.metadata.#{field} data with a value of '#{value}' for all episodes" do
      @data['data'].each do |ep|
        ep['metadata']['show']['metadata'][field.to_s].should == value
      end
    end
  end

  %w(name legacyId state).each do |data|
    it "should return metadata.#{data} key for all seasons" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(name legacyId state).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

###################################################

describe "V3 Object API -- Episodes Smoke Tests -- /episodes/season/#{ObjectIds.season_id}?count=50" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/episodes/season/#{ObjectIds.season_id}?count=50"
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
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  {'count'=>50,'startIndex'=>0,'endIndex'=>49,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return fifty objects" do
    @data['data'].length.should == 50
  end

  ['episodeId','metadata','system'].each do |data|
    it "should return #{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol.has_key?(data).should be_true
        vol[data].should_not be_nil
        vol[data].to_s.length.should > 0
      end
    end
  end

  it "should return a episodeId value that is a 24-character hash for all episodes" do
    @data['data'].each do |vol|
      vol['episodeId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  it "should return metadata.season.seasonId data with a value of #{ObjectIds.season_id} for all episodes" do
    @data['data'].each do |ep|
      ep['metadata']['season']['seasonId'].should == ObjectIds.season_id.to_s
    end
  end

  {:slug=>'batman-the-animated-series-season-1',:legacyId=>909539}.each do |field,value|
    it "should return metadata.season.metadata.#{field} data with a value of '#{value}' for all episodes" do
      @data['data'].each do |ep|
        ep['metadata']['season']['metadata'][field.to_s].should == value
      end
    end
  end

  %w(name legacyId state).each do |data|
    it "should return metadata.#{data} key for all seasons" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
      end
    end
  end

  %w(legacyId state).each do |data|
    it "should return metadata.#{data} data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['metadata'].has_key?(data).should be_true
        vol['metadata'][data].should_not be_nil
        vol['metadata'][data].to_s.delete('^a-z0-9').length.should > 0
      end
    end
  end

  ['createdAt','updatedAt'].each do |data|
    it "should return system.createdAt data with a non-nil, non-blank value for all episodes" do
      @data['data'].each do |vol|
        vol['system'].has_key?(data).should be_true
        vol['system'][data].should_not be_nil
        vol['system'][data].to_s.length.should > 0
      end
    end
  end

end

