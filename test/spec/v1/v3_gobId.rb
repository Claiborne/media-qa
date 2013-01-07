# This is the script to get the objects ID's from v3 video api and check total videos is been greater than zero in v1 api.

require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'

describe "v3gobIds" do

first_page_items = []
tab = []

before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v3_gobId.yml"
    @config = PathConfig.new
  end

  after(:each) do

  end
 it "should return 20 videos" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v3/videos?count=1000"
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
    end
  puts first_page_items.size
  
  first_page_items.each do |legacyId|    
    response = RestClient.get "http://api.ign.com/v1/games/#{legacyId}"    
    data = JSON.parse(response.body)["game"]
      if data["totalVideos"] === 0
         tab << legacyId
    end    
      end
      puts "Unique Items size #{tab.uniq.size}"      
      tab.uniq.each do |unique_id|
        puts "Zero videos for LegacyId #{unique_id}"
      end      
    end
 end
 