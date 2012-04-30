require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'post_search/object_post_search'

include Assert
include ObjectPostSearch

@@token = '2b405d3ee81080c402f9de4897a377056c86f1bb'
@@number = Random.rand(10000).to_s

@@game_slug = "qa-test-game-#{@@number}"
@@game_id = ""

@@company_slug = "qa-test-company-#{@@number}"
@@company_id = ""

@@feature_slug = "qa-test-company-#{@@number}"
@@feature_id = ""

@@genre_slug = "qa-test-genre-#{@@number}"
@@genre_id = ""

@@hardware_slug = "qa-test-hardware-#{@@number}"
@@hardware_id = ""

@@market_slug = "qa-test-market-#{@@number}"
@@market_id = ""

@@release_id = ""

# FIRST SET: CREATE
# SECOND SET: UPDATES
# THIRD SET: CHECK UPDATES

################################## FIRST SET: CREATE ################################## 

describe "V3 Object API -- Create Game", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/games?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/games?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_game_body(@@game_slug), :content_type => "application/json"
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
  
  it "should return a gameId key" do
    @data.has_key?('gameId').should be_true  
  end
  
  it "should return a gameId value that is a 24-character hash" do
    @data['gameId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@game_id = @data['gameId']
  end
    
end

describe "V3 Object API -- Create Company", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/companies?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/companies?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_company_body(@@number,@@company_slug), :content_type => "application/json"
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

  it "should return a gameId key" do
    @data.has_key?('companyId').should be_true  
  end

  it "should return a companyId value that is a 24-character hash" do
    @data['companyId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@company_id = @data['companyId']
  end
  
end

describe "V3 Object API -- Create Feature", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/features?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/features?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_feature_body(@@number,@@feature_slug), :content_type => "application/json"
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

  it "should return a featureId key" do
    @data.has_key?('featureId').should be_true
  end

  it "should return a featureId value that is a 24-character hash" do
    @data['featureId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@feature_id = @data['featureId']
  end
  
end

describe "V3 Object API -- Create Genre", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/genres?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/genres?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_genre_body(@@number,@@genre_slug), :content_type => "application/json"
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

  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true
  end

  it "should return a genreId value that is a 24-character hash" do
    @data['genreId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@genre_id = @data['genreId']
  end
  
end

describe "V3 Object API -- Create Hardware", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/hardware?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/hardware?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_hardware_body(@@number,@@hardware_slug,@@company_id), :content_type => "application/json"
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

  it "should return a hardwareId key" do
    @data.has_key?('hardwareId').should be_true
  end

  it "should return a hardwareId value that is a 24-character hash" do
    @data['hardwareId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@hardware_id = @data['hardwareId']
  end
  
end

describe "V3 Object API -- Create Market", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/markets?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/markets?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_market_body(@@number,@@market_slug), :content_type => "application/json"
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

  it "should return a marketId key" do
    @data.has_key?('marketId').should be_true
  end

  it "should return a marketId value that is a 24-character hash" do
    @data['marketId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@market_id = @data['marketId']
  end
  
end

describe "V3 Object API -- Create Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/releases?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/releases?oauth_token=#{@@token}"
    begin 
      @response = RestClient.post @url, create_release_body(@@number,@@game_id,@@company_id,@@feature_id,@@genre_id,@@hardware_id,@@market_id), :content_type => "application/json"
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

  it "should return a releaseId key" do
    @data.has_key?('releaseId').should be_true
  end

  it "should return a releaseId value that is a 24-character hash" do
    @data['releaseId'].match(/^[0-9a-f]{24,32}$/).should be_true
    @@release_id = @data['releaseId']
  end
  
end

################################## SECOND SET: UPDATES ################################## 

describe "V3 Object API -- Update Game", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/games/#{@@game_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/games/#{@@game_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_game_body(@@game_slug), :content_type => "application/json"
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
  
  it "should return a gameId key" do
    @data.has_key?('gameId').should be_true  
  end
  
  it "should return a gameId value of #{@@game_id}" do
    @data['gameId'].should == @@game_id.to_s
  end
  
end

describe "V3 Object API -- Update Company", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/companies/#{@@company_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/companies/#{@@company_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_company_body(@@number,@@company_slug), :content_type => "application/json"
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
  
  it "should return a companyId key" do
    @data.has_key?('companyId').should be_true  
  end
  
  it "should return a companyId value of #{@@company_id}" do
    @data['companyId'].should == @@company_id.to_s
  end
  
end

describe "V3 Object API -- Update Feature", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/features/#{@@feature_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/features/#{@@feature_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_feature_body(@@number,@@feature_slug), :content_type => "application/json"
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
  
  it "should return a featureId key" do
    @data.has_key?('featureId').should be_true  
  end
  
  it "should return a featureId value of #{@@feature_id}" do
    @data['featureId'].should == @@feature_id.to_s
  end
  
end

describe "V3 Object API -- Update Genre", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/genres/#{@@genre_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/genres/#{@@genre_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_genre_body(@@number,@@genre_slug), :content_type => "application/json"
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
  
  it "should return a genreId key" do
    @data.has_key?('genreId').should be_true  
  end
  
  it "should return a genreId value of #{@@genre_id}" do
    @data['genreId'].should == @@genre_id.to_s
  end
  
end

describe "V3 Object API -- Update Hardware", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/hardware/#{@@hardware_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/hardware/#{@@hardware_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_hardware_body(@@number,@@hardware_slug), :content_type => "application/json"
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
  
  it "should return a hardwareId key" do
    @data.has_key?('hardwareId').should be_true  
  end
  
  it "should return a hardwareId value of #{@@hardware_id}" do
    @data['hardwareId'].should == @@hardware_id.to_s
  end
  
end

describe "V3 Object API -- Update Market", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/markets/#{@@market_id}?oauth_token=#{@@token}"
    @url = "http://10.92.218.26:8080/markets/#{@@market_id}?oauth_token=#{@@token}"
    begin 
      @response = RestClient.put @url, update_market_body(@@number,@@market_slug), :content_type => "application/json"
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
  
  it "should return a marketId value of #{@@market_id}" do
    @data['marketId'].should == @@market_id.to_s
  end
  
end

################################## THIRD SET: CHECK UPDATES ################################## 

describe "V3 Object API -- Check Nested Updates Reflect in Release", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    #@url = "http://#{@config.options['baseurl']}/releases/#{@@release_id}
    @url = "http://10.92.218.26:8080/releases/#{@@release_id}"
    begin 
      @response = RestClient.get @url
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
  
  it "should return metadata.game.gameId with a value of #{@@game_id}" do
    @data['metadata']['game']['gameId'].should == @@game_id  
  end
  
  it "should return metadata.game.metadata.slug with the updated value" do
    @data['metadata']['game']['metadata']['slug'].match(/updated/).should be_true 
  end
  
  it "should return companies.publishers.companyId with a value of #{@@company_id}" do
    @data['companies']['publishers'][0]['companyId'].should == @@company_id
  end
  
  ['publishers','developers'].each do |co_type|
    ['slug','name','alternateNames','commonName',"description"].each do |field|
      it "should return companies.#{co_type}.metadata.#{field} with the updated value" do
        @data['companies'][co_type][0]['metadata'][field].to_s.match(/updated/).should be_true
      end
    end
  end
  
  it "should return content.supports.featureId with a value of #{@@feature_id}" do
    @data['content']['supports'][0]['featureId'].should == @@feature_id
  end
  
  ['name','description','slug','valueOneLabel'].each do |field|
    it "should return content.supports.metadata.#{field} with the updated value" do
      @data['content']['supports'][0]['metadata'][field].to_s.match(/updated/).should be_true
    end  
  end
  
  it "should return content.supports.metadata.valueTwoLabel with the added value" do
    @data['content']['supports'][0]['metadata']['valueTwoLabel'].to_s.match(/added/).should be_true
  end
  
  it "should return content.primaryGenre.genreId with a value of #{@@genre_id}" do
    @data['content']['primaryGenre']['genreId'].should == @@genre_id
  end
  
  ['name','description','slug'].each do |field|
    it "should return content.primaryGenre.metadata.#{field} with the updated value" do
      @data['content']['primaryGenre']['metadata'][field].to_s.match(/updated/).should be_true
    end
  end
  
  it "should return hardware.platform.hardwareId with a value of #{@@hardware_id}" do
    @data['hardware']['platform']['hardwareId'].should == @@hardware_id
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
  
  it "should return hardware.platform.releaseDate.released with the updated value" do
    @data['hardware']['platform']['metadata']['releaseDate']['released'].should == true
  end
  
  it "should return purchasing.buy.marketId with a value of #{@@market_id}" do
    @data['purchasing']['buy'][0]['marketId'].should == @@market_id
  end

  ['name','description','slug'].each do |field|
    it "should return purchasing.buy.metadata.#{field} with the updated value" do
      @data['purchasing']['buy'][0]['metadata'][field].to_s.match(/updated/).should be_true
    end  
  end

end
