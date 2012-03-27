require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

def basic_checks
  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with five indices" do
    check_indices(@data, 5)
  end
  
  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'startIndex' data with a non-nil, non-blank value" do
    @data.has_key?('startIndex').should be_true
    @data['startIndex'].should_not be_nil
    @data['startIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'endIndex' data with a non-nil, non-blank value" do
    @data.has_key?('endIndex').should be_true
    @data['endIndex'].should_not be_nil
    @data['endIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  
  it "should return 'isMore' data with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'isMore' data with a value of true" do
    @data['isMore'].should == true
  end
  
  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'data' with an array length of 20" do
    @data['data'].length.should == 20
  end

  [ "articleId",
    "metadata", 
    "tags", 
    "refs",
    "authors",
    "categoryLocales",
    "categories",
    "content"].each do |k| 
    it "should return non-nil '#{k}' data for all articles" do
      @data['data'].each do |article|
        article.has_key?(k).should be_true
        article.should_not be_nil
        article.to_s.length.should > 0
      end
    end    
  end#end iteration
  
  # articleId assertions
  
  it "should return non-nil, non-blank 'articleId' data for all articles" do
    @data['data'].each do |article|
      article['articleId'].should_not be_nil
      article['articleId'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  it "should return an articleId with a 24-character hash value for all articles" do
    @data['data'].each do |article|
      article['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end
  
  # metadata assertions
  
  ["headline",
    "state",
    "slug",
    "publishDate",
    "articleType",].each do |k|
      
    it "should return '#{k}' metadata for all articles" do
      @data['data'].each do |article|
        article['metadata'].has_key?(k).should be_true
      end
    end
    
    it "should return non-nil, non-blank '#{k}' metadata for all articles" do
      @data['data'].each do |article|
        article['metadata'][k].should_not be_nil
        article['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
    
  end
  
  # legacyData assertions
  
  # tags assertions
  
  # refs assertions
  
  # authors assertions
  
  # categoryLocales assertions
  
  # promo assertions
  
  # categories assertions
  
  # content assertions
  
end#end def

# BEGIN SPEC
##################################################################

['article','post','cheat'].each do |call|
describe "V3 Articles API -- Get Published Article Type: #{call} -- v3/articles/type/#{call}?metadata.state=published", :smoke => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/type/#{call}?metadata.state=published"
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
  
  it "should return an 'articleType' of '#{call}' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == call
    end
  end
  
  it "should only return published articles" do
    @data['data'].each do |article|
      article['metadata']['state'].should == 'published'
    end
  end

  context "Basic Checks" do
    basic_checks
  end
  
end
end

##################################################################