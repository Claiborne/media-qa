require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

class CreateSmokeHelperVars
  
  @token = return_topaz_token('objects')
  
  @number = Random.rand(10000).to_s
  
  @object = {}.to_json
  
  def self.return_token
    @token
  end
  
  def self.return_number
    @number
  end
  
  def self.set_object(o)
    @object = o
  end
  
  def self.return_object
    @object
  end

end

shared_examples "v3 object create smoke state is draft" do

  it "should autogenerate a metadata.state field with a value of 'draft' when none is specified" do
    CreateSmokeHelperVars.return_object['metadata']['state'].should == 'draft'
  end

end

shared_examples "v3 object create smoke" do |objectId|

  it "should not return blank data" do
    check_not_blank CreateSmokeHelperVars.return_object
  end

  it "should return a #{objectId} key" do
    CreateSmokeHelperVars.return_object.has_key?(objectId).should be_true
  end

  it "should return a #{objectId} value that is a 24-character hash" do
    CreateSmokeHelperVars.return_object[objectId].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  ['createdAt','updatedAt'].each do |val|
    it "should autogenerate system.#{val} field" do
      CreateSmokeHelperVars.return_object.has_key?('system').should be_true
      CreateSmokeHelperVars.return_object['system'].has_key?(val).should be_true
    end

    it "should autogenerate system.#{val} value" do
      CreateSmokeHelperVars.return_object['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  unless objectId == 'seasonId'

    it "should autogenerate metadata.legacyId field" do
      CreateSmokeHelperVars.return_object.has_key?('metadata').should be_true
      CreateSmokeHelperVars.return_object['metadata'].has_key?('legacyId').should be_true
    end

    it "should autogenerate metadata.legacyId value" do
      CreateSmokeHelperVars.return_object['metadata']['legacyId'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

  end

end

############################# BEGIN SPEC #############################

describe "V3 Object API -- Create Release Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('release'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('release'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Release Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_release, :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases/#{@data['releaseId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end

  include_examples "v3 object create smoke state is draft"

  it_behaves_like "v3 object create smoke", 'releaseId'
  
  it "should autogenerate metadata.state field" do
    CreateSmokeHelperVars.return_object.has_key?('metadata').should be_true
    CreateSmokeHelperVars.return_object['metadata'].has_key?('state').should be_true
  end
  
  it "should autogenerate metadata.state value" do
    CreateSmokeHelperVars.return_object['metadata']['state'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should autogenerate metadata.state with a value of 'draft'" do
    CreateSmokeHelperVars.return_object['metadata']['state'].should == 'draft'
  end

  it "should return a 404 when deleting the release" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases/#{@data['releaseId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases/#{@data['releaseId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Game Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('game'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('game'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Game Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_game, :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{@data['gameId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'gameId'

  it "should return a 404 when deleting the game" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{@data['gameId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/games/#{@data['gameId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Company Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('company'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Company Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('company'), :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies/#{@data['companyId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'companyId'

  it "should return a 404 when deleting the company" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies/#{@data['companyId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/companies/#{@data['companyId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Feature Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('feature'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Feature Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('feature'), :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features/#{@data['featureId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'featureId'

  it "should return a 404 when deleting the feature" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features/#{@data['featureId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/features/#{@data['featureId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Genre Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('genre'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Genre Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('genre'), :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres/#{@data['genreId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'genreId'

  it "should return a 404 when deleting the genre" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres/#{@data['genreId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/genres/#{@data['genreId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Hardware Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('hardware'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Hardware Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('hardware'), :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware/#{@data['hardwareId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'hardwareId'

  it "should return a 404 when deleting the hardware" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware/#{@data['hardwareId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/hardware/#{@data['hardwareId']}"}.to raise_error(RestClient::ResourceNotFound)
  end
  
end

###############################################################

describe "V3 Object API -- Create Market Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.name is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
  it "should return a 400 when metadata.slug is missing" do
     Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{CreateSmokeHelperVars.return_token}"
      expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('market'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
  
end

###############################################################

describe "V3 Object API -- Create Market Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin 
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('market'), :content_type => "application/json"
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
  
  it "should return a 200 when called via GET" do
    begin 
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets/#{@data['marketId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end       
  end
  
  it_behaves_like "v3 object create smoke", 'marketId'

  it "should return a 404 when deleting the market" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets/#{@data['marketId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/markets/#{@data['marketId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Movie Negative Smoke", :stg => true do
=begin
  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('movie'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('movie'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
=end
  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('movie'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('movie'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Movie Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('movie'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{@data['movieId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it "should not return blank data" do
    check_not_blank CreateSmokeHelperVars.return_object
  end

  it "should return a movieId key" do
    CreateSmokeHelperVars.return_object.has_key?('movieId').should be_true
  end

  it "should return a movieId value that is a 24-character hash" do
    CreateSmokeHelperVars.return_object['movieId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  ['createdAt','updatedAt'].each do |val|
    it "should autogenerate system.#{val} field" do
      CreateSmokeHelperVars.return_object.has_key?('system').should be_true
      CreateSmokeHelperVars.return_object['system'].has_key?(val).should be_true
    end

    it "should autogenerate system.#{val} value" do
      CreateSmokeHelperVars.return_object['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a 404 when deleting the movie" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{@data['movieId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/movies/#{@data['movieId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Book Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('book'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('book'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Book Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('book'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/#{@data['bookId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it "should not return blank data" do
    check_not_blank CreateSmokeHelperVars.return_object
  end

  it "should return a bookId key" do
    CreateSmokeHelperVars.return_object.has_key?('bookId').should be_true
  end

  it "should return a bookId that is a 24-character hash" do
    CreateSmokeHelperVars.return_object['bookId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  ['createdAt','updatedAt'].each do |val|
    it "should autogenerate system.#{val} field" do
      CreateSmokeHelperVars.return_object.has_key?('system').should be_true
      CreateSmokeHelperVars.return_object['system'].has_key?(val).should be_true
    end

    it "should autogenerate system.#{val} value" do
      CreateSmokeHelperVars.return_object['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a 404 when deleting the book" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/#{@data['bookId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/books/#{@data['bookId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Volume Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('volume'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('volume'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('volume'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('volume'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Volume Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('volume'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/#{@data['volumeId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  include_examples "v3 object create smoke state is draft"

  it "should autogenerate metadata.state field" do
    CreateSmokeHelperVars.return_object.has_key?('metadata').should be_true
    CreateSmokeHelperVars.return_object['metadata'].has_key?('state').should be_true
  end

  it "should autogenerate metadata.state value" do
    CreateSmokeHelperVars.return_object['metadata']['state'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should autogenerate metadata.state with a value of 'draft'" do
    CreateSmokeHelperVars.return_object['metadata']['state'].should == 'draft'
  end

  it "should not return blank data" do
    check_not_blank CreateSmokeHelperVars.return_object
  end

  it "should return a volumeId key" do
    CreateSmokeHelperVars.return_object.has_key?('volumeId').should be_true
  end

  it "should return a volumeId that is a 24-character hash" do
    CreateSmokeHelperVars.return_object['volumeId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  ['createdAt','updatedAt'].each do |val|
    it "should autogenerate system.#{val} field" do
      CreateSmokeHelperVars.return_object.has_key?('system').should be_true
      CreateSmokeHelperVars.return_object['system'].has_key?(val).should be_true
    end

    it "should autogenerate system.#{val} value" do
      CreateSmokeHelperVars.return_object['system'][val].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return a 404 when deleting the volume" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/#{@data['volumeId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/volumes/#{@data['volumeId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################
=begin
describe "V3 Object API -- Create Role Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('role'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('role'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('role'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('role'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end
=end
###############################################################

describe "V3 Object API -- Create Role Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_role('role'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{@data['roleId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it_behaves_like "v3 object create smoke", 'roleId'

  it "should return a 404 when deleting the role" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{@data['roleId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roles/#{@data['roleId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Person Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('people'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('people'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('people'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('people'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Person Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('people'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{@data['personId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  include_examples "v3 object create smoke state is draft"

  it_behaves_like "v3 object create smoke", 'personId'

  it "should return a 404 when deleting the person" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{@data['personId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/people/#{@data['personId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create RoleType Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('roletype'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('roletype'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('roletype'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('roletype'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create RoleType Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('roletype'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes/#{@data['roleTypeId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it_behaves_like "v3 object create smoke", 'roleTypeId'

  it "should return a 404 when deleting the roletype" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes/#{@data['roleTypeId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/roleTypes/#{@data['roleTypeId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Character Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('character'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('character'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('character'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('character'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Character Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('character'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{@data['characterId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  include_examples "v3 object create smoke state is draft"

  it_behaves_like "v3 object create smoke", 'characterId'

  it "should return a 404 when deleting the character" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{@data['characterId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/characters/#{@data['characterId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Show Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('show'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('show'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when length of metadata.name is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_name('show'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.name is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_name('show'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

end

###############################################################

describe "V3 Object API -- Create Show Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_object('show'), :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows/#{@data['showId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  include_examples "v3 object create smoke state is draft"

  it_behaves_like "v3 object create smoke", 'showId'

  it "should return a 404 when deleting the show" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows/#{@data['showId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/shows/#{@data['showId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

###############################################################

describe "V3 Object API -- Create Season Negative Smoke", :stg => true do

  it "should return a 400 when length of metadata.slug is zero" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_with_zero_length_slug('season'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end

  it "should return a 400 when metadata.slug is missing" do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons?oauth_token=#{CreateSmokeHelperVars.return_token}"
    expect { RestClient.post @url, V3ObjCreateSmoke.create_object_no_slug('season'), :content_type => "application/json" }.to raise_error(RestClient::BadRequest)
  end
end

###############################################################

describe "V3 Object API -- Create Season Positive Smoke", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_game, :content_type => "application/json"
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

  it "should return a 200 when called via GET" do
    begin
      response = RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons/#{@data['seasonId']}"
      check_200 response
      CreateSmokeHelperVars.set_object JSON.parse(response.body)
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it_behaves_like "v3 object create smoke", 'seasonId'

  it "should return a 404 when deleting the season" do

    del_url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons/#{@data['seasonId']}?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.delete del_url
    rescue => e
      raise Exception.new(e.message+" "+del_url)
    end

    expect {RestClient.get "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/seasons/#{@data['seasonId']}"}.to raise_error(RestClient::ResourceNotFound)
  end

end

########################## JSON BODY FOR WRITES ##########################

module V3ObjCreateSmoke

########## CREATE VALID ##########

def self.create_valid_release
  {
    "metadata" => {
      "name" => "Media QA Test Release or Obj #{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end

def self.create_valid_game
  {
    "metadata" => {
      "slug" => "media-qa-test-obj-#{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end

def self.create_valid_object(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{CreateSmokeHelperVars.return_number}",
      "slug" => "media-qa-test-#{obj}-#{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end

def self.create_valid_role(obj)
  {
  }.to_json
end

########## CREATE INVALID ##########

def self.create_object_with_zero_length_name(obj)
  {
    "metadata" => {
      "name" => "",
      "slug" => "media-qa-test-#{obj}-#{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end


def self.create_object_no_name(obj)
  {
    "metadata" => {
      "slug" => "media-qa-test-#{obj}-#{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end

def self.create_object_with_zero_length_slug(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{CreateSmokeHelperVars.return_number}",
      "slug" => ""
    }
  }.to_json
end


def self.create_object_no_slug(obj)
  {
    "metadata" => {
      "name" => "Media QA Test #{obj} #{CreateSmokeHelperVars.return_number}"
    }
  }.to_json
end

end
