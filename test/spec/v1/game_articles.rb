require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'net/http'
require 'uri'

describe "game articles" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return valid game articles" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games/827005/articles.json?max=10&networkid=12"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   valid_url_list = Array.new
   url_list = Array.new
   flag = true
   data['articles']['article'].each do |item|
     url_list << item['@url']
   end
   url_list.each do |url|
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    #puts "#{response.code} => #{url}"
    if response.code.to_i.eql?(200)
      valid_url_list << url
    end
   end

    valid_url_list.length.should eql(url_list.length)

  end

end
