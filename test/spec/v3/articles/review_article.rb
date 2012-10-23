require 'rspec'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'
require 'article_api_helper'

include Assert
include TopazToken

class ArticleReviewHelper

  @rand_num = Random.rand(100000-999999)

  @article_id = "ARTICLE_ID"

  def self.rand_num
    @rand_num
  end

  def self.set_article_id(id)
    @article_id  = id
  end

  def self.return_article_id
    @article_id
  end

end

##################################################################

describe "V3 Articles API -- Create A Review Article -- POST media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles?oauth_token={token}", :stg => true do

  before(:all) do
    TopazToken.set_token('articles')
    @url = "http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, ArticleAPIHelper.new_review_article(ArticleReviewHelper.rand_num), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.response+"\n"+e.message+" "+@url)
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

  it "should return an 'articleID' key" do
    @data.has_key?('articleId').should be_true
  end

  it "should return an 'articleID' value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    ArticleReviewHelper.set_article_id(@data['articleId'].to_s)
    puts @data['articleId'].to_s
  end

end

##################################################################

describe "V3 Articles API -- Check Review Article Just Created -- media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}", :stg => true do

  before(:all) do
    TopazToken.set_token('articles')
    @url = "http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.response+"\n"+e.message+" "+@url)
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

  {:headline => "Media QA Test Review Article #{ArticleReviewHelper.rand_num}", :slug => "media-qa-test-review-article-#{ArticleReviewHelper.rand_num}", :articleType => 'article', :state => 'draft', :headerVideoUrl => 'http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary', :headerImageUrl => 'http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg'}.each do |k,v|
    it "should return the correct metadata.#{k} value" do
      @data['metadata'][k.to_s].should == v
    end
  end

  it "should return the correct authors.name value" do
    @data['authors'][0]['name'].should == 'Media-QA'
  end

  it "should return the correct 'content' value" do
    @data['content'].should == ["Test Content Body. Media QA Test Article..."]
  end

  {:highlights => ['highlight summary 1','highlight summary 2'], :blurb => 'a short blurb', :score => 9.5, :comment => 'comments', :pros => %w(graphics sound), :cons => %w(story voice), :nominations => %w(nom1 nom2), :editorsChoice => true}.each do |k,v|
    it "should return the correct review.#{k} value" do
      @data['review'][k.to_s].should == v
    end
  end

  it "should return the correct review.breakdown.name values" do
    @data['review']['breakdown'][0]['name'].should == 'Gameplay'
    @data['review']['breakdown'][1]['name'].should ==  'Presentation'
  end

  it "should return the correct review.breakdown.score values" do
    @data['review']['breakdown'][0]['score'].should == 9.0
    @data['review']['breakdown'][1]['score'].should == 9.0
  end

  it "should return the correct review.breakdown.comment values" do
    @data['review']['breakdown'][0]['comment'].should == 'comments'
    @data['review']['breakdown'][1]['comment'].should == 'comments'
  end

  it "should return the correct sideBars.headline values" do
    @data['sideBars'][0]['headline'].should == 'side headline 1'
  end

  it "should return the correct sideBars.summary values" do
    @data['sideBars'][0]['summary'].should == 'side content 1'
  end

  it "should return the correct legacyData.objectRelations value" do
    @data['legacyData']['objectRelations'].should == [111122]
  end

  it "should return the correct legacyData.relatedWorks value" do
    @data['legacyData']['relatedWorks'].should == [61088, 83607]
  end

  it "should return the correct relatedWorks.headline value" do
    @data['relatedWorks']['headline'].should == 'related works headline'
  end

end

##################################################################

describe "V3 Articles API -- Change A Review Article -- PUT media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}", :stg => true do

  before(:all) do
    TopazToken.set_token('articles')
    @url = "http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, ArticleAPIHelper.changed_review_article, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.response+"\n"+e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  after(:all) do
    sleep 5
  end

  it "should return a response of 200" do
    @response.code.should eql(200)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return an 'articleID' key with the correct value" do
    @data['articleId'].should == ArticleReviewHelper.return_article_id
  end

end

##################################################################

describe "V3 Articles API -- Check Review Article Just Changed -- media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.response+"\n"+e.message+" "+@url)
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

  {:headline => "Media QA Test Review Article #{ArticleReviewHelper.rand_num}", :slug => "media-qa-test-review-article-#{ArticleReviewHelper.rand_num}", :articleType => 'article', :state => 'published', :headerVideoUrl => 'http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary', :headerImageUrl => 'http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg'}.each do |k,v|
    it "should return the correct metadata.#{k} value" do
      @data['metadata'][k.to_s].should == v
    end
  end

  it "should return the correct authors.name value" do
    @data['authors'][0]['name'].should == 'Media-QA'
  end

  it "should return the correct 'content' value" do
    @data['content'].should == ["Test Content Body. Media QA Test Article..."]
  end

  {:highlights => ['highlight summary 1','highlight summary 2', 'added'], :blurb => 'a short blurb changed', :score => 9.5, :comment => 'comments', :pros => %w(graphics sound added), :cons => %w(story voice), :nominations => %w(nom1 nom2 added), :editorsChoice => true}.each do |k,v|
    it "should return the correct review.#{k} value" do
      @data['review'][k.to_s].should == v
    end
  end

  it "should return the correct review.breakdown.name values" do
    @data['review']['breakdown'][0]['name'].should == 'Gameplay'
    @data['review']['breakdown'][1]['name'].should ==  'Presentation'
    @data['review']['breakdown'][2]['name'].should ==  'Sound'
  end

  it "should return the correct review.breakdown.score values" do
    @data['review']['breakdown'][0]['score'].should == 9.0
    @data['review']['breakdown'][1]['score'].should == 9.0
    @data['review']['breakdown'][2]['score'].should ==  8.5
  end

  it "should return the correct review.breakdown.comment values" do
    @data['review']['breakdown'][0]['comment'].should == 'comments'
    @data['review']['breakdown'][1]['comment'].should == 'comments'
    @data['review']['breakdown'][2]['comment'].should ==  'comments'
  end

  it "should return the correct sideBars.headline values" do
    @data['sideBars'][0]['headline'].should == "changed"
    @data['sideBars'][1]['headline'].should == 'side headline 2'
  end

  it "should return the correct sideBars.summary values" do
    @data['sideBars'][0]['summary'].should == 'side content 1'
    @data['sideBars'][1]['summary'].should == 'side content 2'
  end

  it "should return the correct legacyData.objectRelations value" do
    @data['legacyData']['objectRelations'].should == [111122]
  end

  it "should return the correct legacyData.relatedWorks value" do
    @data['legacyData']['relatedWorks'].should == [61088, 83607, 122888]
  end

  it "should return the correct relatedWorks.headline value" do
    @data['relatedWorks']['headline'].should == 'related works headline changed'
  end

end

####################################################################
# CLEAN UP / DELETE RELEASE

describe "V3 Articles API -- Clean up / Delete -- media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}", :stg => true do

  before(:all) do
    @url = "http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.delete @url
    rescue => e
      raise Exception.new(e.response+"\n"+e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 404 after deleting the article" do
    sleep 6
    expect {RestClient.get "media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/#{ArticleReviewHelper.return_article_id}"}.to raise_error(RestClient::ResourceNotFound)
  end

end