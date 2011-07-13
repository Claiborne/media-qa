require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "articles" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return valid articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end
  
  ['us','uk','au'].each do |locale|
    it "should return valid articles filtered by #{locale} locale" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.#{locale}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
    end
  end

  ['json','xml'].each do |format|
    it "should return valid articles in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.#{format}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
    end
  end

  it "should return valid articles filtered by franchise id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?franchiseId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty franchise" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?franchiseId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for missing franchise" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?franchiseId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return valid articles filtered by network id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?networkId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty network id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?networkId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for missing network" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?networkId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  ['reviews', 'previews', 'features', 'news', 'promotions', 'videos', 'images'].each do |type|
    it "should return valid articles filtered by #{type}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?types=#{type}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
    end
  end

  it "should return valid articles filtered by all types" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?types=reviews,previews,features,news,promotions,videos,images"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty type" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?types="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for unsupported type" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?types=unsupported"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?sort=popularity"    
   response.code.should eql(200)
   data = JSON.parse(response.body)   
  end

  it "should return articles sorted by published date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty sort" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?sort="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for unsupported sort" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?sort=unsupported"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted in descending order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?order=desc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles sorted in ascending order" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?order=asc"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles 25 articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?max=25"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles 75 articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?max=75"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty max" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?max="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for invalid max" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?max=-1"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return article count satisfying condition" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?getCount"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return articles filtered by channel id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?channelId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty channel id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?channelId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for invalid channel id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?channelId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

 it "should return articles filtered by hub id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?hubId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty hub id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?hubId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for invalid hub id" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles?hubId="
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

end
