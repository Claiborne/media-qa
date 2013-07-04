require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

class ArticlePromoFieldsHelper

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
  
  def self.search_article
    {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
         "field"=>"tags.slug",
         "condition"=>"containsAll",
         "value"=>"one,two"
      },
    ],
    "startIndex"=>0,
    "count"=>20,
    "fromDate"=>"2011-10-00T00:00:00-0000",
    "toDate"=>"2014-07-02T14:55:40-0000"
    }.to_json
  end

  def self.body_request
    {
        "metadata" => {
            "headline"=>"Media QA Test Article #{Random.rand(100000-999999)}",
            "articleType"=>"article",
            "state"=>"published",
        },
        "authors" => [
            {
                "name"=>"Media-QA"
            }
        ],
        "promo"=>{
           "title"=>"blogroll title",
           "summary"=>"blogroll summary",
           "url"=>"promo url",
           "videoUrl"=>"http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary",
           "promoImages"=>[
              {
                "imageId"=>"123", 
                "styleUrl"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg", 
                "url"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg",
                "imageType"=>"big"
              },
              {
                "imageId"=>"1234", 
                "styleUrl"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test2.jpg", 
                "url"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test2.jpg",
                "imageType"=>"small"
              }
           ]
        },
        "content" => ["This article is only meant to test updating, editing, and deleting promo fields"]
    }.to_json
  end
  
  def self.body_update
    {
        "promo"=>{
           "title"=>"blogroll title updated",
           "summary"=>"blogroll summary updated",
           "url"=>"promo url updated",
           "videoUrl"=>"http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary-updated",
           "promoImages"=>[
              {
                "imageId"=>"123updated", 
                "styleUrl"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/updated.jpg", 
                "url"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/updated.jpg",
                "imageType"=>"bigupdated"
              },
              {
                "imageId"=>"1234updated", 
                "styleUrl"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/updated2.jpg", 
                "url"=>"http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/updated2.jpg",
                "imageType"=>"smallupdated"
              }
           ]
        },
    }.to_json
  end

end

##################################################################

describe "V3 Articles API -- Create Article with Promo Fields", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles?oauth_token=#{ArticlePromoFieldsHelper.return_token}&fresh=true"
    begin
      @response = RestClient.post @url, ArticlePromoFieldsHelper.body_request, :content_type => "application/json"
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

  it "should return a response of 201" do
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
    puts @data['articleId'].to_s
    ArticlePromoFieldsHelper.set_article_id(@data['articleId'].to_s)
  end

end

####################################################################

describe "V3 Articles API -- Check Promo Fields", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}?fresh=true"
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
    
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "shoud return an 'articleID' key" do
    @data.has_key?('articleId').should be_true
  end
  
  {"title"=>"blogroll title",
   "summary"=>"blogroll summary",
   "url"=>"promo url",
   "videoUrl"=>"http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary",
  }.each do |k,v|
    
  it "should return the correct promo.#{k} value" do
    @data['promo'][k].should == v      
  end
  end
  
  it "should return the correct promo.promoImages values" do
    @data['promo']['promoImages'][0]['imageId'].should == '123'
    @data['promo']['promoImages'][0]['styleUrl'].should == "http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg"
    @data['promo']['promoImages'][0]['url'].should == "http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg"
    @data['promo']['promoImages'][0]['imageType'].should == 'big'
    
    @data['promo']['promoImages'][1]['imageId'].should == '1234'
    @data['promo']['promoImages'][1]['styleUrl'].should == "http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test2.jpg"
    @data['promo']['promoImages'][1]['url'].should == "http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test2.jpg"
    @data['promo']['promoImages'][1]['imageType'].should == 'small'
    
  end
  
end

##################################################################

describe "V3 Articles API -- Update Article with Promo Fields", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}?oauth_token=#{ArticlePromoFieldsHelper.return_token}&fresh=true"
    begin
      @response = RestClient.put @url, ArticlePromoFieldsHelper.body_update, :content_type => "application/json"
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
  
end

####################################################################

describe "V3 Articles API -- Check Updated Promo Fields", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}?fresh=true"
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
    
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end
  
  %w(title summary url videoUrl).each do |k|
  it "should return the updated promo.#{k} value" do
    @data['promo'][k].to_s.match(/updated/).should be_true
  end
  end
  
  it "should return the correct promo.promoImages values" do
    @data['promo']['promoImages'][0]['imageId'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][0]['styleUrl'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][0]['url'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][0]['imageType'].to_s.match(/updated/).should be_true
    
    @data['promo']['promoImages'][1]['imageId'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][1]['styleUrl'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][1]['url'].to_s.match(/updated/).should be_true
    @data['promo']['promoImages'][1]['imageType'].to_s.match(/updated/).should be_true
  end
  
end

####################################################################
# CLEAN UP / DELETE ARTICLE

describe "V3 Articles API -- Clean up / Delete -- apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}?oauth_token=#{ArticlePromoFieldsHelper.return_token}&fresh=true"
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
    expect {RestClient.get "apis.stg.ign.com/article/v3/articles/#{ArticlePromoFieldsHelper.return_article_id}?fresh=true"}.to raise_error(RestClient::ResourceNotFound)
  end

end

