require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

########################### BEGIN REQUEST BODY METHODS #############################

def release_search_smoke
  {
    "rules"=>[
      {
        "field"=>"hardware.platform.metadata.slug",
        "condition"=>"term",
        "value"=>"xbox-360"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>75,
    "sortBy"=>"metadata.releaseDate.date",
    "sortOrder"=>"desc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to_json
end

def reviewed_games
  {
    "rules"=>[
      {
        "field"=>"network.ign.review.score",
        "condition"=>"exists",
        "value"=>""
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>75,
    "sortBy"=>"network.ign.review.score",
    "sortOrder"=>"desc",
    "states"=>["published"]
  }.to_json
end

def mass_effect_3_releases_by_game_id
  {
    "rules"=>[
      {
        "field"=>"metadata.game.gameId",
        "condition"=>"term",
        "value"=>"4fa34fa18a1606f0a2a6978f"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>10,
    "states"=>["published"]
  }.to_json  
end

def mass_effect_3_releases_by_game_legacyid
  {
    "rules"=>[
      {
        "field"=>"metadata.legacyId",
        "condition"=>"term",
        "value"=>"110694"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>10,
    "states"=>["published"]
  }.to_json 
end

def mass_effect_3_releases_by_game_slug
  {
    "rules"=>[
      {
        "field"=>"metadata.game.metadata.slug",
        "condition"=>"term",
        "value"=>"mass-effect-3"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>10,
    "states"=>["published"]
  }.to_json
end

def bioware_games_by_dev_name
  {
    "rules"=>[
      {
        "field"=>"companies.developers.metadata.name",
        "condition"=>"term",
        "value"=>"bioware"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>25,
    "states"=>["published"]
  }.to_json
end

def bioware_games_by_dev_legacyid
  {
    "rules"=>[
      {
        "field"=>"companies.developers.metadata.legacyId",
        "condition"=>"term",
        "value"=>"26717"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>25,
    "states"=>["published"]
  }.to_json
end

def release_by_is_released(is_released)
  {
    "rules"=>[
      {
        "field"=>"metadata.releaseDate.released",
        "condition"=>"term",
        "value"=>is_released.to_s
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>100,
    "states"=>["published"]
  }.to_json
end

def release_pagination(count,start_index)
  {
    "rules"=>[
      {
        "field"=>"hardware.platform.metadata.slug",
        "condition"=>"term",
        "value"=>"xbox-360"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>start_index.to_i,
    "count"=>count.to_i,
    "sortBy"=>"metadata.releaseDate.date",
    "sortOrder"=>"desc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to_json
end

########################### BEGIN ASSERTION METHODS #############################

def common_assertions(data_count)
  
  it "should return a hash with five indices" do
    check_indices(@data, 6)
  end

  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'count' data with a value of #{data_count}" do
    @data['count'].should == data_count
  end

  it "should return 'startIndex' data with a non-nil, non-blank value" do
    @data.has_key?('startIndex').should be_true
    @data['startIndex'].should_not be_nil
    @data['startIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'startIndex' data with a value of 0" do
    @data['startIndex'].should == 0
  end

  it "should return 'endIndex' data with a non-nil, non-blank value" do
    @data.has_key?('endIndex').should be_true
    @data['endIndex'].should_not be_nil
    @data['endIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'endIndex' data with a value of #{data_count-1}" do
    @data['endIndex'].should == data_count-1
  end

  it "should return 'isMore' data with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'isMore' data with a value of true" do
    @data['isMore'].should == true
  end
  
  it "should return 'total' data with a non-nil, non-blank value" do
    @data.has_key?('total').should be_true
    @data['total'].should_not be_nil
    @data['total'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'total' data with a value of #{data_count}" do
    @data['total'].should > data_count
  end

  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'data' with an array length of #{data_count}" do
    @data['data'].length.should == data_count
  end
  
end

def check_id(id)
  it "should return a #{id} value that is a 24-character hash for all releases" do
    @data['data'].each do |release|
      release[id].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end
end

############################ BEGIN SPEC #################################### 


describe "V3 Object API -- GET Search for Published 360 Releases: #{release_search_smoke}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+release_search_smoke.to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end
  
  common_assertions(75)
  
  check_id('releaseId')
  
  it "should return a releaseId value that is a 24-character hash for all releases" do
    @data['data'].each do |release|
      release['releaseId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end
  
  it "should only return releases with a hardware.platform.metadata.slug value of 'xbox-360'" do
    @data['data'].each do |release| 
      release['hardware']['platform']['metadata']['slug'].should == 'xbox-360'
    end 
  end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
  it "should only return releases with a metadata.region value of 'US'" do
    @data['data'].each do |release| 
      release['metadata']['region'].should == 'US'
    end
  end
  
end

################################################################ 

describe "V3 Object API -- GET Search for Reviewed Releases: #{reviewed_games}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+reviewed_games.to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end
  
  common_assertions(75)
  
  check_id('releaseId')
  
  it "should return network.ign.review.score data with a numeric value for all releases" do
    @data['data'].each do |release|
      release['network']['ign']['review']['score'].to_s.delete('^0-9').length.should > 0
    end
  end
  
  it "should return releases in descending network.ign.review.score order" do
      scores = []
      @data['data'].each do |release|
        scores << release['network']['ign']['review']['score']
      end  
      scores.sort{|x,y| y <=> x }.should == scores
    end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
  
end

################################################################ 

{mass_effect_3_releases_by_game_id=>'GameId',mass_effect_3_releases_by_game_legacyid=>'LegacyId',mass_effect_3_releases_by_game_slug=>'Game Slug'}.each do |request_body,description|
  describe "V3 Object API -- GET Search for Releases by #{description} using: #{request_body}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/releases/search?q="+request_body.to_s
      @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

    after(:all) do

    end

    it "should return at least 4 releases" do
      @data['data'].count.should > 3  
    end

    check_id('releaseId')
    
    it "should only return releases with a metadata.game.gameId value of '4fa34fa18a1606f0a2a6978f'" do
      @data['data'].each do |release|
        release['metadata']['game']['gameId'].should == '4fa34fa18a1606f0a2a6978f'
      end
    end
    
    if description=='LegacyId'
    it "should only return releases with a metadata.legacyId value of '110694" do
      @data['data'].each do |release|
        release['metadata']['legacyId'].should == 110694
      end
    end
    end
    
    it "should only return releases with a metadata.game.slug value of 'mass-effect-3" do
      @data['data'].each do |release|
        release['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
      end
    end

  end
end
################################################################ 

describe "V3 Object API -- GET Search for Bioware Releases By Dev Name: #{bioware_games_by_dev_name}" do
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+bioware_games_by_dev_name.to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end
  
  common_assertions(25)
  
  check_id('releaseId')

  it "should only return companies.developers.metadata.name data with a value of 'BioWare'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['name']
      end
      developers.to_s.downcase.match(/bioware/).should be_true
    end
  end

  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
end

################################################################ 

describe "V3 Object API -- GET Search for Bioware Releases By Dev legacyId: #{bioware_games_by_dev_legacyid}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+bioware_games_by_dev_legacyid.to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end
  
  common_assertions(25)
  
  check_id('releaseId')
  
  it "should only return companies.developers.metadata.name data with a value of 'BioWare'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['name']
      end
      developers.include?('BioWare').should be_true
    end
  end
  
  it "should only return companies.developers.metadata.legacyId data with a value of '26717'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['legacyId']
      end
      developers.include?(26717).should be_true
    end
  end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
end

################################################################ 
[true,false].each do |is_released|
describe "V3 Object API -- GET Search for Releases Released Boolean: #{release_by_is_released(is_released)}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+release_by_is_released(is_released).to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end
  
  common_assertions(100)
  
  it "should only return releases with a metadata.releaseDate.released boolean value of #{is_released}" do
    @data['data'].each do |release|
      release['metadata']['releaseDate']['released'].should == is_released  
    end  
  end
  
end
end
################################################################ 

describe "V3 Object API -- GET Search - Test Pagination Using: #{release_pagination(11,0)}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+release_pagination(11,0).to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin 
       @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
    
    @eleventh_entry = @data['data'][10]['releaseId']
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
   
  it "should pass basic pagination check" do
    begin 
      @url2 = "http://#{@config.options['baseurl']}/releases/search?q="+release_pagination(10,10).to_s
      @url2 = @url2.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      @response = RestClient.get @url2
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
    @data['data'][0]['releaseId'].should == @eleventh_entry
  end
  
end