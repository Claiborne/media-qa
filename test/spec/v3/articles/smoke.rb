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

end
end

##################################################################

{"Slug"=>"/slug/apple-iphone-4s-review", "ID"=>"/4e9cb2997ebbd863360000a2"}.each do |k,v|

describe "V3 Articles API: Smoke Get Article By #{k}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_art.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles#{v}"
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
    it "should return an article with a #{k} key" do
      @data.has_key?(k).should be_true
    end
  end
  
  ["headline",
    "networks",
    "state",
    "slug",
    "subHeadline",
    "publishDate",
    "articleType",].each do |k|
    if k == "networks" 
    it "should return an article with non-nil, non-blank #{k} metadata"
    else 
    it "should return an article with non-nil, non-blank #{k} metadata" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
    end
  end
  
  it "should return an article with a numberic wordpressId" do
    @data['refs'].has_key?('wordpressId').should be_true
    @data['refs']['wordpressId'].should_not be_nil
    @data['refs']['wordpressId'].to_s.delete("^0-9").length.should > 0
  end
  
  it "should return an article with a numberic disqusId" do
    @data['refs'].has_key?('disqusId').should be_true
    @data['refs']['disqusId'].should_not be_nil
    @data['refs']['disqusId'].to_s.delete("^0-9").length.should > 0
  end
  
  it "should return an article with an _id hash with 24 characters" do
    @data['_id'].should_not be_nil
    @data['_id'].match(/^[0-9a-f]{24,32}$/).should be_true
  end
  
  it "should return an article with a non-blank, non-nil createdAt value" do
    @data['system'].has_key?('createdAt').should be_true
    @data['system']['createdAt'].should_not be_nil
    @data['system']['createdAt'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil updatedAt value" do
    @data['system'].has_key?('updatedAt').should be_true
    @data['system']['updatedAt'].should_not be_nil
    @data['system']['updatedAt'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil author-name value" do
    @data['authors'].has_key?('name').should be_true
    @data['authors']['name'].should_not be_nil
    @data['authors']['name'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil categoryLocales value" do
    @data['categoryLocales'].should_not be_nil
    @data['categoryLocales'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil categories value" do
    @data['categories'].should_not be_nil
    @data['categories'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil tags value" do
    @data['tags'].should_not be_nil
    @data['tags'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return an article with a non-blank, non-nil content value" do
    @data['content'].should_not be_nil
    @data['content'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

end
end