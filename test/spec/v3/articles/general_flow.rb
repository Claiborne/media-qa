require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

class HelperVarsArticleFlow

  @article_id = "ARTICLE_ID"

  @token = return_topaz_token('articles')

  def self.return_token
    @token
  end

  def self.return_article_id
    @article_id
  end

  def self.set_article_id(id)
    @article_id  = id
  end

  def self.body_request
    {
        "metadata" => {
            "headline"=>"Media QA Test Article #{Random.rand(100000-999999)}",
            "articleType"=>"article",
            "state"=>"published"
        },
        "authors" => [
            {
                "name"=>"Media-QA"
            }
        ],
        "content" => ["Test Content Body. Media QA Test Article..."]
    }.to_json
  end

end

##################################################################

describe "V3 Articles API -- Create An Article -- POST apis.stg.ign.com/article/v3/articles?oauth_token={token}", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles?oauth_token=#{HelperVarsArticleFlow.return_token}&fresh=true"
    begin
      @response = RestClient.post @url, HelperVarsArticleFlow.body_request, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  after(:all) do
    sleep 3
  end

  it "should return a response of 200" do
    @response.code.should eql(201)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "shoud return an 'articleID' key" do
    @data.has_key?('articleId').should be_true
  end

  it "should return an 'articleID' value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    HelperVarsArticleFlow.set_article_id(@data['articleId'].to_s)
    puts @data['articleId'].to_s
  end

end

##################################################################

describe "V3 Articles API -- Check Article Just Created -- apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?fresh=true"
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

  after(:all) do
    sleep 3
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  ["articleId",
    "metadata",
    "review",
    "legacyData",
    "metadata",
    "system",
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "promo",
    "categories",
    "content"].each do |k|
    it "should return an article with #{k} data" do
      @data.has_key?(k).should be_true
    end
  end

  ["articleId",
    "metadata",
    #"review",
    #"legacyData",
    "metadata",
    "system",
    #"tags",
    #"refs",
    "authors",
    #"categoryLocales",
    #"promo",
    #"categories",
    #"content"
    ].each do |k|
    it "should return an article with non-nil, non-blank #{k} data" do
      @data[k].should_not be_nil
      @data[k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  # articleId assertions

  it "should return an article with an articleId value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  it "should return an article with an articleId value of #{HelperVarsArticleFlow.return_article_id}" do
    @data['articleId'].should == HelperVarsArticleFlow.return_article_id
  end

  # metadata assertions

  ["headline",
    #"networks",
    "state",
    "slug",
    "articleType"].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' metadata" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return an article with a slug value that includes 'media-qa-test-article'" do
    @data['metadata']['slug'].match(/media-qa-test-article/).should be_true
  end

  it "should return an article in the 'published' state" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return an article with an articleType value of 'article'" do
    @data['metadata']['articleType'].should == 'article'
  end

  it "should return an article with a headline value that includes 'Media QA Test Article'" do
    @data['metadata']['headline'].match(/Media QA Test Article/).should be_true
  end

  # review assertions

  # legacyData assertions

  # system assertions

  ['createdAt','updatedAt'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data" do
      @data['system'].has_key?(k).should be_true
      @data['system'][k].should_not be_nil
      @data['system'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  # tags assertions
=begin
  it "should return an article with 15 non-nil, non-blank tags" do
    @data['tags'].length.should == 15
    @data['tags'].each do |tag|
      tag.should_not be_nil
      tag.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data for each tag" do
      @data['tags'].each do |tag|
        tag.has_key?(k).should be_true
        tag[k].should_not be_nil
        tag[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
=end
  # refs assertions

  # authors assertions

  it "should return an article with an author-name value of 'Media-QA'" do
    @data['authors'][0].has_key?('name').should be_true
    @data['authors'][0]['name'].should_not be_nil
    @data['authors'][0]['name'].to_s.delete("^a-zA-Z0-9").length.should > 0
    @data['authors'][0]['name'].should == 'Media-QA'
  end

  # categoryLocales assertions

  # promo assertions

  # categories assertions
=begin
  it "should return an article with 4 non-nil, non-blank categories" do
    @data['categories'].length.should == 4
    @data['categories'].each do |categories|
      categories.should_not be_nil
        ategories.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank #{k} data for each categories" do
      @data['categories'].each do |categories|
        categories.has_key?(k).should be_true
        categories[k].should_not be_nil
        categories[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
=end
  # content assertions

  it "should return an article with content value of 'Test Content Body. Media QA Test Article...'" do
    @data['content'][0].should == "Test Content Body. Media QA Test Article..."
  end
end

##################################################################

describe "V3 Articles API -- Update Article Just Created -- PUT apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?oauth_token={token}", :stg => true do

  before(:all) do
    put_body = {"content" => ["Test Content Change #{Random.rand(10000-99999)}"]}.to_json
    @url = "http://apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?oauth_token=#{HelperVarsArticleFlow.return_token}&fresh=true"
    begin
      @response = RestClient.put @url, put_body, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
      @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  after(:all) do
    sleep 3
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should return an article with an articleId value of #{HelperVarsArticleFlow.return_article_id}" do
    @data['articleId'].should == HelperVarsArticleFlow.return_article_id
  end

end

##################################################################

describe "V3 Articles API -- Check Article Just Updated -- apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?fresh=true"
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

  after(:all) do
    sleep 3
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return an article with content value of 'Test Content Change'" do
    @data['content'][0].match(/Test Content Change/).should be_true
  end

  ["articleId",
    "metadata",
    "review",
    "legacyData",
    "metadata",
    "system",
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "promo",
    "categories",
    "content"].each do |k|
    it "should return an article with #{k} data" do
      @data.has_key?(k).should be_true
    end
  end

  ["articleId",
    "metadata",
    #"review",
    #"legacyData",
    "metadata",
    "system",
    #"tags",
    #"refs",
    "authors",
    #"categoryLocales",
    #"promo",
    #"categories",
    #"content"
    ].each do |k|
    it "should return an article with non-nil, non-blank #{k} data" do
      @data[k].should_not be_nil
      @data[k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  # articleId assertions

  it "should return an article with an articleId value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end

  it "should return an article with an articleId value of #{HelperVarsArticleFlow.return_article_id}" do
    @data['articleId'].should == HelperVarsArticleFlow.return_article_id
  end

  # metadata assertions

  ["headline",
    #"networks",
    "state",
    "slug",
    "articleType"].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' metadata" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return an article with a slug value that includes 'media-qa-test-article'" do
    @data['metadata']['slug'].match(/media-qa-test-article/).should be_true
  end

  it "should return an article in the 'published' state" do
    @data['metadata']['state'].should == 'published'
  end

  it "should return an article with an articleType value of 'article'" do
    @data['metadata']['articleType'].should == 'article'
  end

  it "should return an article with a headline value that includes 'Media QA Test Article'" do
    @data['metadata']['headline'].match(/Media QA Test Article/).should be_true
  end

  # review assertions

  # legacyData assertions

  # system assertions

  ['createdAt','updatedAt'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data" do
      @data['system'].has_key?(k).should be_true
      @data['system'][k].should_not be_nil
      @data['system'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  # tags assertions
=begin
  it "should return an article with 15 non-nil, non-blank tags" do
    @data['tags'].length.should == 15
    @data['tags'].each do |tag|
      tag.should_not be_nil
      tag.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data for each tag" do
      @data['tags'].each do |tag|
        tag.has_key?(k).should be_true
        tag[k].should_not be_nil
        tag[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
=end
  # refs assertions

  # authors assertions

  it "should return an article with an author-name value of 'Media-QA'" do
    @data['authors'][0].has_key?('name').should be_true
    @data['authors'][0]['name'].should_not be_nil
    @data['authors'][0]['name'].to_s.delete("^a-zA-Z0-9").length.should > 0
    @data['authors'][0]['name'].should == 'Media-QA'
  end

  # categoryLocales assertions

  # promo assertions

  # categories assertions
=begin
  it "should return an article with 4 non-nil, non-blank categories" do
    @data['categories'].length.should == 4
    @data['categories'].each do |categories|
      categories.should_not be_nil
        ategories.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank #{k} data for each categories" do
      @data['categories'].each do |categories|
        categories.has_key?(k).should be_true
        categories[k].should_not be_nil
        categories[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
=end
  # content assertions

end

####################################################################
# CLEAN UP / DELETE RELEASE

describe "V3 Articles API -- Clean up / Delete -- apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?oauth_token=#{HelperVarsArticleFlow.return_token}&fresh=true"
    begin
      @response = RestClient.delete @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 404 after deleting the article" do
    expect {RestClient.get "apis.stg.ign.com/article/v3/articles/#{HelperVarsArticleFlow.return_article_id}?fresh=true"}.to raise_error(RestClient::ResourceNotFound)
  end

end
