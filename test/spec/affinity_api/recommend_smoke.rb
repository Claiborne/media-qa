require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'affinity_api_helper'

include Assert
include AffinityApiHelper

def large_game_request
  "117913,14290332,14332801,714955,5990,108945,111269,94303,131324,94304,128052,115080,852012,121190,14354769,123177,123489,117407,77702,57305,107963,110033,14350224,130552,115645,83711,69279,112453,14235016,110860,110765,122254,852011,123170,81897,867592,95028,59789,83,907969,80427,793105,14235013,19159,734817,14236766,77615,14253761,830467,64330,14276699,839087,879549,83916,900961,85769,102230,113047,105972,112934,91667,85967,78532,103210,106214,110281,108191"
end

[2,10,30].each do |count|
["110563", "110563,35905", large_game_request].each do |game_id|

describe "Affinity API -- do=recommend&id=#{game_id}&count=#{count}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/affinity_api.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}?do=recommend&id=#{game_id}&count=#{count}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return a hash with five indices" do
    check_indices(@data, 4)
  end

  affinity_api_common_checks

  it "should return 'Data' with a length of #{count}" do
    @data['Data'].length == count
  end

  it "should return #{count} Data.gameId non-nil, non-blank values" do
    @data['Data'].each do |game|
      game.has_key?('gameId').should be_true
      game['gameId'].should_not be_nil
      game['gameId'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should not return any Data.gameId values that match the game id sent in the service request" do
    game_id.split(",").each do |request_id|
      @data['Data'].each do |game|
        game['gameId'].should_not == request_id.to_i
      end
    end
  end

  it "should return #{count} Data.score non-nil, non-blank values" do
    @data['Data'].each do |game|
      game.has_key?('score').should be_true
      game['score'].should_not be_nil
      game['score'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return unique Data.score values" do
    score_data = []
    @data['Data'].each do |game|
      score_data << game['gameId']
    end
    score_data.uniq.should == score_data
  end

  it "should return score values in descending order" do
    score_data = []
    @data['Data'].each do |game|
      score_data << game['score']
    end
    score_data.sort{|x,y| y <=> x }.should == score_data
  end

  affinity_api_response_time(30)

end
end
end