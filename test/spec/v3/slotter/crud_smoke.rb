require 'rspec'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'
require 'time'
require 'slotter_api_helper'

include Assert
include TopazToken

# Create Slotter Meta Entry
# Get Slotter Meta Entry by /ID
# Create Slotter Content
# Check Slotter Content
# Publish Slotter Content
# Check Published Content
# Update Content
# Check Updated Content
# Publish Updated Content
# Check Updated Published Content
# Delete Slotter Meta Entry

describe "V3 Slotter API -- Create Slotter Meta Entry", :stg => true do

  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, {"name"=>"Media QA Test #{Random.rand(10000-9999999)}"}.to_json, {:content_type => "application/json", :Principal => "wclaiborne Test Automation"}
      sleep 2
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end
  
  it "should return an id value" do
    puts @data['id']
    SlotterAPIHelper.id = @data['id']
  end

end

describe "V3 Slotter API -- Get Slotter Meta Entry by /ID", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end
  
  it "should return the appropiate id value" do
    @data['id'].should == SlotterAPIHelper.id
  end
  
  %w(timestamp _rTimestamp).each do |key|
  it "should return a #{key} that is within 5 mins" do
    time_diff = Time.parse(@data[key]) - Time.now
    time_diff.abs.should < 60*5
  end
  end
  
  it "should return the appropriate slug" do
    begin
      @data['slug'].match(/media-qa-test-\d/).should be_true 
    rescue => e
      raise e, "\nExpected: media-qa-test-#\nGot: #{@data['slug']}"
    end
  end
  
  it "should return the appropriate name" do
    begin
      @data['name'].match(/Media QA Test \d/).should be_true 
    rescue => e
      raise e, "\nExpected: Media QA Test #\nGot: #{@data['name']}"
    end
  end
  
  it "should return the appropriate principal" do
    @data['principal'].should == "wclaiborne Test Automation"  
  end

end

describe "V3 Slotter API -- Create Slotter Content", :stg => true do
  
  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/versions?oauth_token=#{TopazToken.return_token}&fresh=true"
    begin
      @response = RestClient.put @url, SlotterAPIHelper.create_slotter_content, {:Principal => "wclaiborne Test Automation", "Content-Type" => 'application/json'}
      sleep 2
    rescue => e
      puts SlotterAPIHelper.create_slotter_content.to_s
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
  it "should return a metaId value" do
    SlotterAPIHelper.content_id = @data['metaId']
  end
  
  it "should return a versionId value" do
    SlotterAPIHelper.version_id = @data['versionId']
  end

end

describe "V3 Slotter API -- Check Slotter Content", :stg => true do
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/_latest?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)['version']
    @items = @data['items']
  end

   include_examples 'check content'
   
end

describe "V3 Slotter API -- Publish Slotter Content", :stg => true do
  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/versions/#{SlotterAPIHelper.version_id}/_publish?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, {}.to_json, {:Principal => "wclaiborne Test Automation", "Content-Type" => 'application/json'}
      sleep 2
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
end

describe "V3 Slotter API -- Check Published Content", :stg => true do
  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/_published?oauth_token=#{TopazToken.return_token}&fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)['version']
    @items = @data['items']
  end
  
    include_examples 'check content'
    
end

describe "V3 Slotter API -- (Smoke) Update Content", :stg => true do
  
  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/versions?oauth_token=#{TopazToken.return_token}&fresh=true"
    change = {:name=>'Media QA Test',:items=>[{:url=>'changed url'}]}.to_json
    begin
      @response = RestClient.put @url, change, {:Principal => "wclaiborne Test Automation", "Content-Type" => 'application/json'}
      sleep 2
    rescue => e
      puts change
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
  it "should return a versionId value" do
    SlotterAPIHelper.version_id = @data['versionId']
  end

end

describe "V3 Slotter API -- Check Updated Content", :stg => true do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/_latest?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
  it "should return the correct (updated) versionId value" do
    @data['version']['versionId'].should == SlotterAPIHelper.version_id
  end
  
  it "should return the correct update" do
    @data['version']['items'][0]['url'].should == 'changed url'
  end
  
end

describe "V3 Slotter API -- Publish Updated Content", :stg => true do
  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/versions/#{SlotterAPIHelper.version_id}/_publish?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, {}.to_json, {:Principal => "wclaiborne Test Automation", "Content-Type" => 'application/json'}
      sleep 2
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
end

describe "V3 Slotter API -- Check Updated Published Content", :stg => true do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}/_published?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    @response.code.should == 200
  end 
  
  it "should return the correct (updated) versionId value" do
    @data['version']['versionId'].should == SlotterAPIHelper.version_id
  end
  
  it "should return the correct update" do
    @data['version']['items'][0]['url'].should == 'changed url'
  end
  
end


describe "V3 Slotter API -- Delete Slotter Meta Entry", :stg => true do

  before(:all) do
    TopazToken.set_token('manage-slotters')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.delete @url, :Principal => "wclaiborne Test Automation"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
  end

  it "should return 202" do
    @response.code.should == 202
  end
  
  it "should return a 404 when requested" do
    expect do
      RestClient.get "http://#{@config.staging['baseurl']}/slotters/#{SlotterAPIHelper.id}"
    end.to raise_error(RestClient::ResourceNotFound)
  end
  
end
