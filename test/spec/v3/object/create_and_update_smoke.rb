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

  @game_id = ""
  @company_id = ""
  @feature_id = ""
  @genre_id = ""
  @hardware_id = ""
  @market_id = ""
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
  
  def self.return_hardware_id
    @hardware_id
  end
  
  def self.return_market_id
    @market_id
  end
  
  def self.return_release_id
    @release_id
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
  
  def self.set_hardware_id(id)
    @hardware_id = id
  end
  
  def self.set_market_id(id)
    @market_id = id
  end
  
  def self.set_release_id(id)
    @release_id = id
  end
  
end

# FIRST SET: CREATE
# SECOND SET: UPDATES
# THIRD SET: CHECK UPDATES
# CLEAN UP: DELETE OBJECTS

################################## FIRST SET: CREATE ################################## 

describe "V3 Object API -- Create Game", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/games?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_game_body(HelperVars.return_object_slug('game')), :content_type => "application/json"
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
    @data['gameId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_game_id @data['gameId']
  end
    
end

#################################################################### 

describe "V3 Object API -- Create Company", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/companies?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_company_body(HelperVars.return_number,HelperVars.return_object_slug('company')), :content_type => "application/json"
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
    @data.has_key?('companyId').should be_true  
  end

  it "should return a companyId value that is a 24-character hash" do
    @data['companyId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_company_id @data['companyId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Feature", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/features?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_feature_body(HelperVars.return_number,HelperVars.return_object_slug('feature')), :content_type => "application/json"
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
    @data['featureId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_feature_id @data['featureId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Genre", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/genres?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_genre_body(HelperVars.return_number,HelperVars.return_object_slug('genre')), :content_type => "application/json"
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
    @data['genreId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_genre_id @data['genreId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Hardware", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/hardware?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_hardware_body(HelperVars.return_number,HelperVars.return_object_slug('hardware'),HelperVars.return_company_id), :content_type => "application/json"
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
    @data['hardwareId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_hardware_id  @data['hardwareId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Market", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/markets?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_market_body(HelperVars.return_number,HelperVars.return_object_slug('market')), :content_type => "application/json"
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
    @data['marketId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVars.set_market_id @data['marketId']
  end
  
end

#################################################################### 

describe "V3 Object API -- Create Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/releases?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.post @url, create_release_body(HelperVars.return_number,HelperVars.return_game_id,HelperVars.return_company_id,HelperVars.return_feature_id,HelperVars.return_genre_id,HelperVars.return_hardware_id,HelperVars.return_market_id), :content_type => "application/json"
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

################################## SECOND SET: UPDATES ################################## 

describe "V3 Object API -- Update Game", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/games/#{HelperVars.return_game_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_game_body(HelperVars.return_object_slug('game')), :content_type => "application/json"
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
    @data['gameId'].should == HelperVars.return_game_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Company", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/companies/#{HelperVars.return_company_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_company_body(HelperVars.return_number,HelperVars.return_object_slug('company')), :content_type => "application/json"
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
    @data['companyId'].should == HelperVars.return_company_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Feature", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/features/#{HelperVars.return_feature_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_feature_body(HelperVars.return_number,HelperVars.return_object_slug('feature')), :content_type => "application/json"
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
    @data['featureId'].should == HelperVars.return_feature_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Genre", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/genres/#{HelperVars.return_genre_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_genre_body(HelperVars.return_number,HelperVars.return_object_slug('genre')), :content_type => "application/json"
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
    @data['genreId'].should == HelperVars.return_genre_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Hardware", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/hardware/#{HelperVars.return_hardware_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_hardware_body(HelperVars.return_number,HelperVars.return_object_slug('hardware')), :content_type => "application/json"
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
    @data['hardwareId'].should == HelperVars.return_hardware_id
  end
  
end

#################################################################### 

describe "V3 Object API -- Update Market", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://10.92.218.26:8080/markets/#{HelperVars.return_market_id}?oauth_token=#{HelperVars.return_token}"
    begin 
      @response = RestClient.put @url, update_market_body(HelperVars.return_number,HelperVars.return_object_slug('market')), :content_type => "application/json"
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
    @data['marketId'].should == HelperVars.return_market_id
  end
  
end

################################## THIRD SET: CHECK UPDATES ################################## 

describe "V3 Object API -- Check Nested Updates Reflect in Release", :test => true do

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
  
  it "should return 200" do  
  end
  
  it "should return the correct metadata.game.gameId value" do
    @data['metadata']['game']['gameId'].should == HelperVars.return_game_id  
  end
  
  it "should return metadata.game.metadata.slug with the updated value" do
    @data['metadata']['game']['metadata']['slug'].match(/updated/).should be_true 
  end
  
  it "should return the correct companies.publishers.companyId value" do
    @data['companies']['publishers'][0]['companyId'].should == HelperVars.return_company_id
  end
  
  ['publishers','developers'].each do |co_type|
    ['slug','name','alternateNames','commonName',"description"].each do |field|
      it "should return companies.#{co_type}.metadata.#{field} with the updated value" do
        @data['companies'][co_type][0]['metadata'][field].to_s.match(/updated/).should be_true
      end
    end
  end
  
  it "should return the correct content.supports.featureId value" do
    @data['content']['supports'][0]['featureId'].should == HelperVars.return_feature_id
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
    @data['content']['primaryGenre']['genreId'].should == HelperVars.return_genre_id
  end
  
  ['name','description','slug'].each do |field|
    it "should return content.primaryGenre.metadata.#{field} with the updated value" do
      @data['content']['primaryGenre']['metadata'][field].to_s.match(/updated/).should be_true
    end
  end
  
  it "should return the correct hardware.platform.hardwareId value" do
    @data['hardware']['platform']['hardwareId'].should == HelperVars.return_hardware_id
  end
  
  ['name','description','slug'].each do |field|
    it "should return hardware.platform.metadata.#{field} with the updated value" do
      @data['hardware']['platform']['metadata'][field].to_s.match(/updated/).should be_true
    end
  end
  
  it "should return hardware.platform.metadata.tyoe with the added value" do
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
    @data['purchasing']['buy'][0]['marketId'].should == HelperVars.return_market_id
  end

  ['name','description','slug'].each do |field|
    it "should return purchasing.buy.metadata.#{field} with the updated value" do
      @data['purchasing']['buy'][0]['metadata'][field].to_s.match(/updated/).should be_true
    end  
  end

end

################################## CLEAN UP: DELETE OBJECTS ##################################

describe "V3 Object API -- Clean Up: Delete Objects", :test => true do

  it "should return a 404 when deleting objects" do

    {:games => HelperVars.return_game_id, :companies => HelperVars.return_company_id, :features => HelperVars.return_feature_id, :genres => HelperVars.return_genre_id, :hardware => HelperVars.return_hardware_id, :markets => HelperVars.return_market_id, :releases => HelperVars.return_release_id}.each do |k,v|

      del_url = "http://10.92.218.26:8080/#{k}/#{v}?oauth_token=#{HelperVars.return_token}"
      begin
        @response = RestClient.delete del_url
      rescue => e
        raise Exception.new(e.message+" "+del_url)
      end

      expect {RestClient.get "http://10.92.218.26:8080/#{k}/#{v}"}.to raise_error(RestClient::ResourceNotFound)
    end
  end
  
end