require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

[ "",
  "?metadata.state=published",
  "/type/post",
  "/type/cheat",
  "/type/article",
  "/state/published"].each do |call|

describe "V3 Articles API: Articles Smoke Tests" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_art.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles#{call}"
    puts @url
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
  
  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end
  
  it "shoud return count with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.length.should > 0
  end
  
  it "should return count with a value of 20" do
    @data['count'].should == 20
  end
  
  it "shoud return startIndex with a non-nil, non-blank value" do
    @data.has_key?('startIndex').should be_true
    @data['startIndex'].should_not be_nil
    @data['startIndex'].to_s.length.should > 0
  end
  
  it "should return startIndex with a value of 0" do
    @data['startIndex'].should == 0
  end
  
  it "shoud return endIndex with a non-nil, non-blank value" do
    @data.has_key?('endIndex').should be_true
    @data['endIndex'].should_not be_nil
    @data['endIndex'].to_s.length.should > 0
  end
  
  it "should return endIndex with a value of 19" do
    @data['endIndex'].should == 19
  end
  
  it "shoud return isMore with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.length.should > 0
  end
  
  it "should return isMore with a value of true" #do
    #@data['isMore'].should == true
  #end

  it "shoud return total with a non-nil, non-blank value" do
    @data.has_key?('total').should be_true
    @data['total'].should_not be_nil
    @data['total'].to_s.length.should > 0
  end
  
  it "should return total with a value greater than 20" #do
    #@data['total'].should > 20
  #end
  
  it "shoud return data with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.length.should > 0
  end
  
  it "should return data with an array length of 20" do
    @data['data'].length.should == 20
  end
  
  it "should return an article _id with non-nil, non-blank value for all articles" do
    @data['data'].each do |article|
      article['_id'].should_not be_nil
      article['_id'].to_s.length.should > 0
    end
  end
  
  it "should return an article _id with a 24 character hash value for all articles" do
    @data['data'].each do |article|
      article['_id'].match(/^[0-9a-f]{24,32}$/).should be_true  
    end
  end

  ["review",
    "legacyData",
    "system", 
    "objectRelation", 
    "metadata", 
    "tags", 
    "refs",
    "_id",
    "authors",
    "categoryLocales",
    "promo",
    "categories",
    "content",
    "metadata",].each do |k| 
    it "should return a #{k} key for all articles" do
      @data['data'].each do |article|
        article.has_key?(k).should be_true
      end
    end
  end
=begin
  it "should return videoId with non-nil, non-blank value for all videos" do
    @data['data'].each do |article|
      article['videoId'].should_not be_nil
      article['videoId'].to_s.length.should > 0
    end
  end
  
  it "should return a hash value for all videoIds" do
    @data['data'].each do |video|
      video['videoId'].match(/^[0-9a-f]{24,32}$/).should be_true  
    end  
  end
=end
end
end