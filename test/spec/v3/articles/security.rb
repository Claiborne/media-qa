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
