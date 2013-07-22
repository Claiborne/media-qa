require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

module BoardsHelper

  # Used to create a new board
  @rand_num1 = Random.rand(1000000)
  @rand_num2 = Random.rand(1000000)
  @rand_num3 = Random.rand(1000000)
  @rand_num4 = Random.rand(1000000)

  # Used to update the new board
  @rand_num5 = Random.rand(1000000)
  @rand_num6 = Random.rand(1000000)
  @rand_num7 = Random.rand(1000000)
  @rand_num8 = Random.rand(1000000)

  class Vars
    @@id

    def self.set_id(id)
      @@id = id
    end

    def self.get_id
      @@id
    end
  end

  def self.new_board
    {
      :xenforoId=>(5111+@rand_num1),
      :primaryLegacyId=>@rand_num2,
      :relatedLegacyIds=>[
        @rand_num3,
        @rand_num4
      ]
    }
  end

  def self.update_board_first
    {
      :primaryLegacyId=>@rand_num5,
      :relatedLegacyIds=>[
        @rand_num6,
        @rand_num7,
        @rand_num8
      ]
    }
  end

  def self.update_board_second
    {
      :relatedLegacyIds=>[
          @rand_num6,
          @rand_num7
      ]
    }
  end

end

describe "V3 Boards API -- Create A Board", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    TopazToken.set_token('boards-admin')
    @url = "http://10.97.64.101:8082/board/v3/boards?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, BoardsHelper.new_board.to_json, :content_type => "application/json"
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
    puts @data['_id']
    BoardsHelper::Vars.set_id @data['_id']
    @response.code.should == 200
  end

  it 'should return the appropriate xenforoId value' do
    @data['xenforoId'].should == BoardsHelper.new_board[:xenforoId]
  end

  it 'should return the appropriate primaryLegacyId value' do
    @data['primaryLegacyId'].should == BoardsHelper.new_board[:primaryLegacyId]
  end

  it 'should return the appropriate relatedLegacyIds value' do
    @data['relatedLegacyIds'].should == BoardsHelper.new_board[:relatedLegacyIds]
  end

end

describe "V3 Boards API -- Get Board Just Created", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    TopazToken.set_token('boards-admin')
    @url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?fresh=true"
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
    @response.code.should == 200
  end

  it 'should return the appropriate xenforoId value' do
    @data['xenforoId'].should == BoardsHelper.new_board[:xenforoId]
  end

  it 'should return the appropriate primaryLegacyId value' do
    @data['primaryLegacyId'].should == BoardsHelper.new_board[:primaryLegacyId]
  end

  it 'should return the appropriate relatedLegacyIds value' do
    @data['relatedLegacyIds'].should == BoardsHelper.new_board[:relatedLegacyIds]
  end

end

describe "V3 Boards API -- Update A Board", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, BoardsHelper.update_board_first.to_json, :content_type => "application/json"
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
    @response.code.should == 200
    sleep 2
  end

  it 'should return the updated values' do
    url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?fresh=true"
    res = RestClient.get url
    data = JSON.parse(res.body)
    data['primaryLegacyId'].should == BoardsHelper.update_board_first[:primaryLegacyId]
    data['relatedLegacyIds'].should == BoardsHelper.update_board_first[:relatedLegacyIds]
  end

end

describe "V3 Boards API -- Update A Board A Second Time", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, BoardsHelper.update_board_second.to_json, :content_type => "application/json"
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
    @response.code.should == 200
    sleep 2
  end

  it 'should return the updated values' do
    url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?fresh=true"
    res = RestClient.get url
    data = JSON.parse(res.body)
    data['relatedLegacyIds'].should == BoardsHelper.update_board_second[:relatedLegacyIds]
  end

end

describe "V3 Boards API -- Delete A Board", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.delete @url
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

  it "should the appropriate delete response" do
    @data.to_json.should == {:msg=>"board with id: #{BoardsHelper::Vars.get_id} deleted."}.to_json
  end

end

describe "V3 Boards API -- Confirm Delete A Board Using '/ID'", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8082/board/v3/boards/#{BoardsHelper::Vars.get_id}?fresh=true"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 404" do
    expect {RestClient.get @url}.to raise_error(RestClient::ResourceNotFound)
  end

end