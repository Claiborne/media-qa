require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "articles" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end

  it "should return valid articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  ['json','xml', 'html'].each do |format|
    it "should return valid articles in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.#{format}"
     response.code.should eql(200)
     if format.eql?("json")
      data = JSON.parse(response.body)
     elsif format.eql?("xml")
       data = Nokogiri::XML(response.body)
     end
    end
  end

  it "should return valid articles filtered by franchise id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?franchiseId=865020"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return valid articles filtered by network id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?networkId=12"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  ['reviews', 'previews', 'features', 'news', 'promotions', 'videos', 'images'].each do |type|
    it "should return valid articles filtered by #{type}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?types=#{type}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
    end
  end

  it "should return valid articles filtered by all types" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?types=reviews,previews,features,news,promotions,videos,images"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return default for empty type" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v2/articles.json?types=")
   response.code.should eql(200)
   data = JSON.parse(response.body)
   
  end

  it "should return articles sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=popularity"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted by published date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted in descending order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?order=desc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted in ascending order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles 25 articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?max=25"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles 75 articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?max=75"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return article count satisfying condition" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?getCount"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles filtered by channel id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?channelId=543"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

 it "should return articles filtered by hub id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?hubId=544"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end
end

