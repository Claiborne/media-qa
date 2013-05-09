require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

module WikiHelper

  @rand_num1 = Random.rand(1000000000)

  class Vars
    @@id

    def self.set_id(id)
      @@id = id
    end

    def self.get_id
      @@id
    end
  end

  def self.new_wiki
    {
      :slug=>"media-qa-test-wiki-#@rand_num1",
      :mediawikiUrl=>"media-qa-test-wiki-#@rand_num1",
      :wikiName=>"Media QA Test Wiki #@rand_num1",
      :status=>"published",
      :hidden=>false,
      :staff=>false,
      :locked=>false,
      :static=>false,
      :hasMap=>false,
      :hasPokedex=>false
    }
  end

  def self.update_wiki_first

  end

  def self.update_wiki_second

  end

end

describe "V3 Wiki API -- Create A Wiki", :stg1 => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    TopazToken.set_token('wiki-admin')
    @url = "http://10.97.64.101:8081/wiki/v3/wikis?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, WikiHelper.new_wiki.to_json, :content_type => "application/json"
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
    puts @data['wikiId']
    WikiHelper::Vars.set_id @data['wikiId']
    @response.code.should == 200
  end

  {:slug=>WikiHelper.new_wiki[:slug], :mediawikiUrl=>WikiHelper.new_wiki[:mediawikiUrl], :wikiName=>WikiHelper.new_wiki[:wikiName], :status=>WikiHelper.new_wiki[:status], :status=>WikiHelper.new_wiki[:status], :hidden=>WikiHelper.new_wiki[:hidden], :staff=>WikiHelper.new_wiki[:staff], :locked=>WikiHelper.new_wiki[:locked], :static=>WikiHelper.new_wiki[:static], :hasMap=>WikiHelper.new_wiki[:hasMap], :hasPokedex=>WikiHelper.new_wiki[:hasPokedex]}.each do |k,v|
  it "should return the appropriate #{k} data" do
    @data[k.to_s].should == v
  end end
end

describe "V3 Wiki API -- Get Wiki Just Created", :stg1 => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8081/wiki/v3/wikis/#{WikiHelper::Vars.get_id}"
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

  {:slug=>WikiHelper.new_wiki[:slug], :mediawikiUrl=>WikiHelper.new_wiki[:mediawikiUrl], :wikiName=>WikiHelper.new_wiki[:wikiName], :status=>WikiHelper.new_wiki[:status], :status=>WikiHelper.new_wiki[:status], :hidden=>WikiHelper.new_wiki[:hidden], :staff=>WikiHelper.new_wiki[:staff], :locked=>WikiHelper.new_wiki[:locked], :static=>WikiHelper.new_wiki[:static], :hasMap=>WikiHelper.new_wiki[:hasMap], :hasPokedex=>WikiHelper.new_wiki[:hasPokedex]}.each do |k,v|
  it "should return the appropriate #{k} data" do
    @data[k.to_s].should == v
  end end

end

describe "V3 Wiki API -- Delete A Wiki", :stg1 => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8081/wiki/v3/wikis/#{WikiHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
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
    @data.to_json.should == {"msg"=>"wiki with id: #{WikiHelper::Vars.get_id} deleted."}.to_json
  end

end

describe "V3 Wiki API -- Confirm Delete A Wiki Using '/ID'", :stg1 => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://10.97.64.101:8082/wiki/v3/wikis/#{WikiHelper::Vars.get_id}"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 404" do
    expect {RestClient.get @url}.to raise_error(RestClient::ResourceNotFound)
  end

end