require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

def body_request
  @body = {
  "matchRule"=>"matchAll",
  "rules"=>[
    {
       "condition"=>"is",
       "field"=>"objectRelations.legacyId",
       "value"=>"872155"
    }
  ],
  "startIndex"=>0,
  "count"=>25,
  "networks"=>"ign",
  "prime"=>"false",
  "states"=>"published"
  }.to_json
end


describe "V3 Video API -- Search/POST Smoke Tests -- POST /v3/videos/search -- Body = #{body_request} " do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search"
    begin
     @response = RestClient.post @url, body_request, :content_type => "application/json"
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
  
  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
  
  it "should return only videos with legacyId data is '872155'" do
    @data['data'].each do |k|
      legacyId_values = []
      k['objectRelations'].each do |l|
        legacyId_values << l['legacyId'].to_i
      end
      legacyId_values.include?(872155).should be_true
    end
  end
  
  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end

  {'start'=>0,'count'=>25,'end'=>24}.each do |k,v|
    it "should return a '#{k}' value of '#{v}'" do
      @data.has_key?(k).should be_true
      @data[k].should == v
    end
  end
  
  it "should return only videos with networks data is 'ign'" do
    networks_metadata = []
    @data['data'].each do |k|
      k['metadata']['networks'].each do |l|
        networks_metadata << l
      end
      networks_metadata.include?("ign").should be_true
    end
  end
  
  it "should return only videos where prime is 'false'" do
    @data['data'].each do |k|
      k['metadata']['prime'].should be_false
    end
  end
  
end



