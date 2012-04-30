require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Object API -- Releases Smoke Tests -- /releases?count=200" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases?count=200"
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
  
  ['releaseId','metadata','hardware','system'].each do |data|
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
      release['releaseId'].match(/^[0-9a-f]{24,32}$/).should be_true
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
    ids = ['4f9e4b9499e7cb98fa81e22e','4f9e4b9499e7cb98fa81e22f','4f9e4b9499e7cb98fa81e22d','4f9e4b9499e7cb98fa81e22c']
    @data['data'].each do |release|
      ids.include?release['releaseId'].should be_true
    end
  end
  
  it "should only return releases with a metadata.game.gameId value of 4f9e4b9299e7cb98fa81e217" do
    @data['data'].each do |release|
      release['metadata']['game']['gameId'].should == '4f9e4b9299e7cb98fa81e217'
    end
  end
  
  it "should only return releases with a metadata.game.metadata.slug value of mass-effect-3" do
    @data['data'].each do |release|
      release['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
    end
  end
  
end

###################################################

describe "V3 Object API -- Releases Smoke Tests -- /releases/4f9e4b9499e7cb98fa81e22d" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/4f9e4b9499e7cb98fa81e22d"
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
  
  it "should return a release with a releaseId value of 4f9e4b9499e7cb98fa81e22d" do
    @data['releaseId'].should == '4f9e4b9499e7cb98fa81e22d'
  end
  
  it "shoud return a release with a metadata.region value of UK" do
    @data['metadata'].has_key?('region').should be_true
    @data['metadata']['region'].should == 'UK'
  end
  
  it "should only return releases with a metadata.game.gameId value of 4f9e4b9299e7cb98fa81e217" do
    @data['metadata']['game']['gameId'].should == '4f9e4b9299e7cb98fa81e217'
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
  
  it "should return 200 games"
  
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
      game['gameId'].match(/^[0-9a-f]{24,32}$/).should be_true
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

['/4f9e4b9299e7cb98fa81e217','/slug/mass-effect-3'].each do |call|
describe "V3 Object API -- Games Smoke Tests -- /games#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/games#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should a release with a gameId value of 4f9e4b9299e7cb98fa81e217" do
    @data.has_key?('gameId').should be_true
    @data['gameId'].should == '4f9e4b9299e7cb98fa81e217'  
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
      company['companyId'].match(/^[0-9a-f]{24,32}$/).should be_true
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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

['/4f9e207499e7cb98fa804e20','/slug/bioware'].each do |call|
describe "V3 Object API -- Companies Smoke Tests -- /companies#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/companies#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a company with a companyId value of 4f9e207499e7cb98fa804e20" do
    @data.has_key?('companyId').should be_true
    @data['companyId'].should == '4f9e207499e7cb98fa804e20'
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
  
  it "should return 200 features"
  
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
      feature['featureId'].match(/^[0-9a-f]{24,32}$/).should be_true
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

describe "V3 Object API -- Features Smoke Tests -- /features/type/online-multiplayer"

###################################################

['/4f9e205a99e7cb98fa804a1b','/slug/1080p'].each do |call|
describe "V3 Object API -- Features Smoke Tests -- /feaures#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/features#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a feature with a featureId value of 4f9e205a99e7cb98fa804a1b" do
    @data.has_key?('featureId').should be_true
    @data['featureId'].should == '4f9e205a99e7cb98fa804a1b'
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
  
  it "should return 200 genres"
  
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
      genre['genreId'].match(/^[0-9a-f]{24,32}$/).should be_true
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

['/4f9e215499e7cb98fa806dc7','/slug/action'].each do |call|
describe "V3 Object API -- Genre Smoke Tests -- /genres#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/genres#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a genre with a genreId value of 4f9e215499e7cb98fa806dc7" do
    @data.has_key?('genreId').should be_true
    @data['genreId'].should == '4f9e215499e7cb98fa806dc7'
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
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
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
  
  it "should return 200 hardwares"
  
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
      hardware['hardwareId'].match(/^[0-9a-f]{24,32}$/).should be_true
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

['/4f9e215899e7cb98fa806e8d','/slug/xbox-360'].each do |call|
describe "V3 Object API -- Hardware Smoke Tests -- /hardware#{call}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/hardware#{call}"
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
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hardware with a hardwareId value of 4f9e215899e7cb98fa806e8d" do
    @data.has_key?('hardwareId').should be_true
    @data['hardwareId'].should == '4f9e215899e7cb98fa806e8d'
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
