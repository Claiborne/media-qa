require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

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
    "count"=>35,
    "sortBy"=>"metadata.releaseDate",
    "sortOrder"=>"asc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to_json
end

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

################################################################ 


describe "V3 Object API -- Post Search for #{release_search_smoke}", :stg => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search"
    begin 
       @response = RestClient.post @url, release_search_smoke, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  common_assertions(35)
  
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
  
end