require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Boards API -- General Gets -- /boards" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/boards?fresh=true"
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

  it "should by default return 10 boards" do
    @data['data'].length.should == 10
  end

  it "should return 'count' with a value of 10" do
    @data['count'].should == 10
  end

  it "should return 'startIndex' with a value of 0" do
    @data['startIndex'].should == 0
  end

  it "should return 'endIndex' with a value of 9" do
    @data['endIndex'].should == 9
  end

  it "should return 'isMore' with a value 'true'" do
    @data['isMore'].should be_true
  end

  it "should have 'xenforoId' data for each board" do
    @data['data'].each do |b|
      b['xenforoId'].should > -1
    end
  end

  it "should have a 'primaryLegacyId' field for each board" do
    @data['data'].each do |b|
      b['primaryLegacyId'].should be_true
    end
  end

  it "should have a 'relatedLegacyIds' field for each board" do
    @data['data'].each do |b|
      b['relatedLegacyIds'].should be_true
    end
  end

  it "should have an '_id' that is a 24-character hash for each board" do
    @data['data'].each do |b|
      b['_id'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

end

describe "V3 Boards API -- General Gets -- /boards?count=200&startIndex=199" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/boards?count=200&startIndex=199&fresh=true"
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

  it "should return 200 boards" do
    @data['data'].length.should == 200
  end

  it "should return 'count' with a value of 200" do
    @data['count'].should == 200
  end

  it "should return 'startIndex' with a value of 199" do
    @data['startIndex'].should == 199
  end

  it "should return 'endIndex' with a value of 398" do
    @data['endIndex'].should == 398
  end

  it "should return 'isMore' with a value 'true'" do
    @data['isMore'].should be_true
  end

  it "should have 'xenforoId' data for each board" do
    @data['data'].each do |b|
      b['xenforoId'].should > -1
    end
  end

  it "should have a 'primaryLegacyId' field for each board" do
    @data['data'].each do |b|
      b['primaryLegacyId'].should be_true
    end
  end

  it "should have a 'relatedLegacyIds' field for each board" do
    @data['data'].each do |b|
      b['relatedLegacyIds'].should be_true
    end
  end

  it "should have an '_id' that is a 24-character hash for each board" do
    @data['data'].each do |b|
      b['_id'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

end