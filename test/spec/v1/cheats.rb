require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'time'

describe "cheats" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return cheats" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats"
   response.code.should eql(200)
   data = Nokogiri::XML(response.body)
  end

  ['json','xml'].each do |format|
    it "should return cheats in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.#{format}"
     response.code.should eql(200)
     if format.eql?('json')
      data = JSON.parse(response.body)
     else
       data = Nokogiri::XML(response.body)
     end
    end
  end

  it "should return cheats for xbox 360" do
   platform_id='661955'
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.json?platform=#{platform_id}"
   response.code.should eql(200)
   flag = true
   data = JSON.parse(response.body)
   data['cheatSummaries']['cheatSummary'].each do |item|
     if !item['@platformId'].eql?(platform_id)
       flag = false
       break
     end
   end
   flag.should be_true
  end 

  it "should return error for unsupported platform" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/cheats.json?platform=-1"){|response, request, result|
   response.code.should eql(200)
   data = JSON.parse(response.body)
   }
  end

  it "should return cheats for retro games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.json?retro=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return cheats sorted by publish date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.json?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   date_list = Array.new
   flag = true
   data['cheatSummaries']['cheatSummary'].each do |item|
     date_list << Time.parse(item['publishDate'])
   end
   for idx in (0..date_list.length-2)
     flag = false unless date_list[idx] >= date_list[idx+1]
   end
   flag.should be_true
  end

  it "should return cheats sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.json?sort=popularity"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty sort" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/cheats.json?sort="){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  it "should return error for unsupported sort" do
   response = RestClient.get ("http://#{@config.options['baseurl']}/v1/cheats.json?sort=unsupported"){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  [25,75].each do |count|
   it "should return limit number of articles to #{count}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/cheats.json?max=#{count}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
     data['cheatSummaries']['cheatSummary'].length.should <= count
   end
  end

end
