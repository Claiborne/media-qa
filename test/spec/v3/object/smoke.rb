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

"where am i - i am below this line changin movie to comic"

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
