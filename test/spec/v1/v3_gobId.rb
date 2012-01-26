# This is the script to get the objects ID's from v3 video api and check total videos is been greater than zero in v1 api.

require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "v3gobIds" do

first_page_items = []
tab = []

before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v3_gobId.yml"
    @config = Configuration.new
  end

  after(:each) do

  end
 it "should return 20 videos" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos?count=100"
    response.code.should eql(200)
    data = JSON.parse(response.body)["data"]
    data.each do |entry|
        if !entry["objectRelations"].nil?
          entry["objectRelations"].each do |block|
            if block["objectType"] === "games" 
              first_page_items << block["legacyId"]
            end
          end
        end
     #first_page_items << data["objectRelations"]["legacyId"] 
    end
  puts first_page_items.size
  
  first_page_items.each do |legacyId|
    #puts "Response code for #{legacyId}"
    response = RestClient.get "http://api.ign.com/v1/games/#{legacyId}"    
    data = JSON.parse(response.body)["game"]
    #puts data
    #puts "Total videos for #{legacyId} is #{data['totalVideos']}"
    if data["totalVideos"] === 0
     tab << data["legacyId"]
     
    puts "Zero videos for legacyId #{legacyId}"
    end    
      end
      puts tab.size
    end

 end
 