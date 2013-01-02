require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'
require 'time'

describe "faqs" do

  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = PathConfig.new
  end

  after(:each) do

  end

  it "should return faqs" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs"    
   response.code.should eql(200)
   data = Nokogiri::XML(response.body)
  end

  ['json','xml'].each do |format|
    it "should return faqs in #{format} format" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.#{format}"
     response.code.should eql(200)
     if format.eql?('json')
      data = JSON.parse(response.body)
     else
       data = Nokogiri::XML(response.body)
     end
    end
  end

  it "should return faqs for xbox 360" do
   platform_id="661955"
   flag=true
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.json?platform=#{platform_id}"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data['faqSummaries']['faqSummary'].each do |item|
     if !item['@platformId'].eql?(platform_id)
       flag = false
       break
     end
   end
   flag.should be_true
  end 

  it "should return error for unsupported platform" do
   response = RestClient.get("http://#{@config.options['baseurl']}/v1/faqs.json?platform=-1"){|response, request, result|
   response.code.should eql(200)
   data = JSON.parse(response.body)
   }
  end

  it "should return faqs for retro games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.json?retro=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return faqs sorted by publish date" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.json?sort=publishDate"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   date_list = Array.new
   flag = true
   data['faqSummaries']['faqSummary'].each do |item|
     date_list << Time.parse(item['@lastPublishDate'])
   end
   for idx in (0..date_list.length-2)
     flag = false unless date_list[idx] >= date_list[idx+1]
   end
   flag.should be_true
  end

  it "should return faqs sorted by popularity" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.json?sort=popularity"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  it "should return error for empty sort" do
   response = RestClient.get("http://#{@config.options['baseurl']}/v1/faqs.json?sort="){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  it "should return error for unsupported sort" do
   response = RestClient.get("http://#{@config.options['baseurl']}/v1/faqs.json?sort=unsupported"){|response, request, result|
   response.code.should eql(404)
   #data = JSON.parse(response.body)
   }
  end

  [25,75].each do |count|
   it "should return limit number of articles to #{count}" do
     response = RestClient.get "http://#{@config.options['baseurl']}/v1/faqs.json?max=#{count}"
     response.code.should eql(200)
     data = JSON.parse(response.body)
     data['faqSummaries']['faqSummary'].length.should <= count
   end
  end

end
