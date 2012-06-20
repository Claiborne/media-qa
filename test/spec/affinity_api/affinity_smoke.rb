require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'affinity_api_helper'

include Assert
include AffinityApiHelper

[2,10,30].each do |count|
%w(94314 734817 83 494).each do |game_id|

describe "Affinity API -- do=affinity&id=#{game_id}&count=#{count}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/affinity_api.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}?do=affinity&id=#{game_id}&count=#{count}"
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

  it "should return #{count} non-nil, non-blank Data.game1Id values" do
    @data['Data'].each do |game|
      game.has_key?('game1Id').should be_true
      game['game1Id'].should_not be_nil
      game['game1Id'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return #{count} non-nil, non-blank Data.game2Id values" do
    @data['Data'].each do |game|
      game.has_key?('game2Id').should be_true
      game['game2Id'].should_not be_nil
      game['game2Id'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return #{count} non-nil, non-blank Data.rank values" do
    @data['Data'].each do |game|
      game.has_key?('rank').should be_true
      game['rank'].should_not be_nil
      game['rank'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return #{count} non-nil, non-blank Data.count values" do
    @data['Data'].each do |game|
      game.has_key?('count').should be_true
      game['count'].should_not be_nil
      game['count'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return #{count} non-nil, non-blank Data.affinity values" do
    @data['Data'].each do |game|
      game.has_key?('affinity').should be_true
      game['affinity'].should_not be_nil
      game['affinity'].to_s.delete('^0-9').length.should > 0
    end
  end

  it "should return the game_id sent in the service request for each Data.game1Id field" do
    @data['Data'].each do |game|
      game['game1Id'].should == game_id.to_i
    end
  end

  it "should not return the game_id sent in the service request for any Data.game2Id field" do
    @data['Data'].each do |game|
      game['game2Id'].should_not == game_id.to_i
    end
  end

  it "should return unique Data.game2Id values" do
    game_2_data = []
    @data['Data'].each do |game|
      game_2_data << game['game2Id']
    end
    game_2_data.uniq.should == game_2_data
  end

  it "should return Data.affinity values in descending order" do
    affinity_data = []
    @data['Data'].each do |game|
      affinity_data << game['affinity']
    end
    affinity_data.sort{|x,y| y <=> x }.should == affinity_data
  end

  it "should return Data.rank values in sequential and ascending order, beginning with 1" do
    i = 1
    @data['Data'].each do |game|
      game['rank'].should == i
      i = i+1
    end
  end

  affinity_api_response_time(30)

end
end
end