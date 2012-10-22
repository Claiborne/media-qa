require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'article_api_helper'
require 'topaz_token'

include Assert
include TopazToken

# GET (UNPUBLISHED) ARTICLES USING STATE/STATE
# GET ARTICLES USING ?METADATA.STATE
# POST SEARCH ARTICLES USING STATE

# GET SINGLE UNPUBLISHED ARTICLE USING ID AND SLUG
  # CREATE
  # GET VIDEO BY ID WITH OAUTH
  # GET VIDEO BY SLUG  WITH OAUTH
  # GET VIDEO BY ID WITHOUT OAUTH
  # GET VIDEO BY SLUG  WITHOUT OAUTH


##################################################################
# GET (UNPUBLISHED) ARTICLES USING STATE/STATE

%w(draft abc).each do |state|
describe "V3 Article API -- GET Unpublished Articles Using /state/#{state} Endpoint", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    TopazToken.set_token('articles')
    @url = "http://#{@config.options['baseurl']}/v3/articles/state/#{state}"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET ARTICLES USING ?METADATA.STATE

%w(draft abc).each do |state|
describe "V3 Article API -- GET Unpublished Articles Using ?metadata.state=#{state} Endpoint", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    TopazToken.set_token('articles')
    @url = "http://#{@config.options['baseurl']}/v3/articles?metadata.state=#{state}"
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# POST SEARCH ARTICLES USING STATE

%w(draft abc).each do |state|
describe "V3 Article API -- GET Unpublished Articles Using ?metadata.state=#{state} Endpoint", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    TopazToken.set_token('articles')
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleAPIHelper.get_articles_by_state(state).to_s
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    TopazToken.set_token('videos')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401 without an oauth token" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

  it "should 200 with an oauth token" do
    res = RestClient.get @url+"&oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end end

##################################################################
# GET SINGLE UNPUBLISHED ARTICLE USING ID AND SLUG

describe "V3 Article API -- GET Specific Non-Published Article", :stg=> true do

  before(:all) do
    TopazToken.set_token('articles')
    @base_url = "media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles"

    @rand_num = Random.rand(500)
    @article_body = {:metadata=>{:headline=>"Media QA Test Article #@rand_num",:articleType=>"article",:state=>"draft"},:authors=>[{:name=>"Media QA"}],:refs=>{:wordpressId=>234209374}}.to_json

    class ArticleData
      @article_id = "No ID"
      def self.article_id=(value)
        @article_id = value
      end
      def self.article_id
        @article_id
      end
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should create a video" do
    res = RestClient.post "#{@base_url}?oauth_token=#{TopazToken.return_token}", @article_body, :content_type => "application/json"
    data = JSON.parse(res.body)
    puts data['articleId']
    ArticleData.article_id= data['articleId']
    res.code.should == 201
    sleep 1
  end

  it "should return a 200 when trying to GET a draft article by articleId with OAuth" do
    res = RestClient.get "#{@base_url}/#{ArticleData.article_id}?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
    d = JSON.parse(res.body)
    d['metadata']['state'].should == "draft"
  end

  it "should return a 200 when trying to GET a draft article by slug with OAuth" do
    res = RestClient.get "#{@base_url}/slug/media-qa-test-article-#@rand_num?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
    d = JSON.parse(res.body)
    d['metadata']['state'].should == "draft"
  end

  it "should return a 401 when trying to GET a draft article by articleId without OAuth" do
    expect {RestClient.get "#{@base_url}/#{ArticleData.article_id}"}.to raise_error(RestClient::Unauthorized)
  end

  it "should return a 404 when trying to GET a draft article by slug without OAuth" do
    expect {RestClient.get "#{@base_url}/slug/media-qa-test-article-#@rand_num"}.to raise_error(RestClient::ResourceNotFound)
  end

  it "should clean up" do
    res = RestClient.delete "#{@base_url}/#{ArticleData.article_id}?oauth_token=#{TopazToken.return_token}"
    res.code.should == 200
  end

end