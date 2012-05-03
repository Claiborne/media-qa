require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "v3 Object Migration" do

  before(:all) do
    @legacy_ids = []
    
    @url = "http://api.ign.com/v1/games.json?max=200&sort=releaseDate&order=desc&startIndex=1"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @v1_data_1 = JSON.parse(@response.body)
    
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  
  it "should get legacyIds" do
    
    @v1_data_1['games']['game'].each do |game|
      @legacy_ids << game['@id'] # store legacy_ids
    end
  end
  
  it "should make checks" do
    
    #puts @v1_data_1['games']['game'][@legacy_ids.index(id)]['@id']+" "+id
    
    @legacy_ids.each do |id| #begin iteration
      
      @v3url = "http://apis.lan.ign.com/object/v3/releases/legacyId/#{id}"
      begin 
        @response = RestClient.get @v3url
      rescue => e
        raise Exception.new(e.message+" "+@v3url+" "+e.response.to_s)
      end
      @v3_data = JSON.parse(@response.body) 
      release = @v3_data['data']
      
      @v1url = "http://api.ign.com/v1/games/#{id}.json?projection=full"
      begin 
        @response = RestClient.get @v1url
      rescue => e
        raise Exception.new(e.message+" "+@v1url+" "+e.response.to_s)
      end
      @v1_data = JSON.parse(@response.body) 
      game = @v1_data['game']
      
      release.each do |r|
        puts r['metadata']['legacyId']+" "+id.to_s
      end
      
    end # end iteration
  end # should
  
end