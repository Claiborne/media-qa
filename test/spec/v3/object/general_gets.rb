require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Object API -- Releases Query Tests -- /releases?count=35&startIndex=35&metadata.state=published&metadata.region=UK" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases?count=35&startIndex=35&metadata.state=published&metadata.region=UK"
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
  
  {'count'=>35,'startIndex'=>35,'endIndex'=>69,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end
  
  it "should return 200 releases" do
    @data['data'].length.should == 35
  end
  
  ['releaseId','metadata','content','hardware','system'].each do |data|
    it "should return #{data} data with a non-nil, not-blank value for all releases" do
      @data['data'].each do |release|
        release.has_key?(data).should be_true
        release[data].should_not be_nil
        release[data].to_s.length.should > 0
      end
    end
  end
  
  # metadata assertions
  
  it "should only return published releases" do
    @data['data'].each do |release|
      release['metadata']['state'].should == 'published'
    end
  end
  
  it "should only return releases of the UK region" do
    @data['data'].each do |release|
      release['metadata']['region'].should == 'UK'
    end
  end
  
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

  # content assertions
  
  # hardware assertions
  
  # system assertoins
  
end
