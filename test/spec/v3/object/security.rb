require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'topaz_token'
require 'object_post_search'

include ObjectPostSearch
include TopazToken

# If a metadata.state other than published is requested and no oauth_token is supplied, the API will return 401

# If no metadata.state parameter is passed in, or if the parameter is empty, the API defaults to published
# Invalid states in metadata.state are now ignored

# If the requested object has metadata.state set to anything other than published, and no oauth_token is supplied by the client, the API will return 401
# This also applies to the /objects endpoint, even though it doesn't return full objects

##################################################################
# If a metadata.state other than published is requested and no oauth_token is supplied, the API will return 401

%w(releases people volumes shows episodes characters roles).each do |obj|
%w(draft deleted).each do |state|
describe "V3 Object API -- GET #{obj} with metadata.state=#{state} WITHOUT OAuth", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/#{obj}?metadata.state=#{state}&count=200&fresh=true"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

end end end

##################################################################
# If no metadata.state parameter is passed in, or if the parameter is empty, the API defaults to published
# Invalid states in metadata.state are now ignored

%w(releases people volumes shows episodes characters roles).each do |obj|
["", ",", "fairy"].each do |state|
%w(0 200 400 600 800).each do |start|
describe "V3 Object API -- GET #{obj} with ?metadata.state=#{state}&count=200&startIndex=#{start} WITHOUT OAuth", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/#{obj}?metadata.state=#{state}&count=200&startIndex=#{start}&fresh=true"

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

  it "should return 200 #{obj}" do
    @data['data'].count.should == 200
  end

  it "should only return published #{obj}" do
    @data['data'].each do |o|
      o['metadata']['state'].should == 'published'
    end
  end

  it "should return only embedded objects with state==published" do
    @data.to_s.match(/"state"=>"draft"/).should_not be_true
    @data.to_s.match(/"state"=>"deleted"/).should_not be_true
  end

end end end end

##################################################################
# If the requested object has metadata.state set to anything other than published, and no oauth_token is supplied by the client, the API will return 401
# This also applies to the /objects endpoint, even though it doesn't return full objects

describe "V3 Object API -- GET Specific Draft & Deleted Object WITHOUT & WITHOUT OAuth", :stg => true do

before(:all) do
  PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
  @config = PathConfig.new
  TopazToken.set_token('objects')
  @base_url = "http://#{@config.stg['baseurl']}/"
  @object_array = []
  @legacy_id_array = []
  @rand_num = Random.rand(10000)

  %w(releases people volumes shows episodes characters roles).each do |obj|
    begin
      response = RestClient.post "#@base_url#{obj}?oauth_token=#{TopazToken.return_token}", create_object_min_both(@rand_num), :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message)
    end
    @object_array << response.body.to_s.match(/[a-z0-9]{24}/)

  end

  obj_ind = 0
  %w(releases people volumes shows episodes characters).each do |obj|
    begin
      response = RestClient.get "#@base_url#{obj}/#{@object_array[obj_ind]}?oauth_token=#{TopazToken.return_token}"
      obj_ind = obj_ind + 1
      data = JSON.parse(response.body)
      @legacy_id_array << data['metadata']['legacyId'].to_s
    rescue => e

    end
  end

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 401 when requesting /ID endpoint on a draft object WITHOUT OAuth" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      expect {RestClient.get "#@base_url#{o}/#{@object_array[i]}"}.to raise_error(RestClient::Unauthorized)
      i = i+1
    end
  end

  it "should return a 401 when requesting /objects endpoint on a draft object WITHOUT OAuth" do
    @legacy_id_array.length.should == 6
    @legacy_id_array[0].to_s.match(/..../).should be_true
    @legacy_id_array.each do |id|
      expect {RestClient.get "#{@base_url}objects/legacyId/#{id}"}.to raise_error(RestClient::Unauthorized)
    end
  end

  it "should return a 200 when requesting /objects endpoint on a draft object WITH OAuth" do
    @legacy_id_array.each do |id|
      res = RestClient.get "#{@base_url}objects/legacyId/#{id}?oauth_token=#{TopazToken.return_token}"
      res.code.should == 200
    end
  end

  it "should not return a result when searching by slug on a draft object WITHOUT OAuth" do

    search_request = {
        "rules"=>[
            {
                "field"=>"metadata.slug",
                "condition"=>"term",
                "value"=>"media-qa-test-object-#@rand_num"
            }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>5,
        "sortBy"=>"system.createdAt",
        "sortOrder"=>"desc",
        "state" => "draft"
    }.to_json

    %w(releases roles).each do |o|
      url = "#@base_url#{o}/search?q=#{search_request}"
      url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      response = RestClient.get url
      data = JSON.parse(response.body)
      data['data'].count.should == 0
    end
  end

  it "should return a result when searching by slug on a draft object WITH OAuth" do

    search_request = {
        "rules"=>[
            {
                "field"=>"metadata.legacyId",
                "condition"=>"exists",
                "value"=>""
            }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>1,
        "state" => "draft"
    }.to_json

    %w(releases roles).each do |o|
      url = "#@base_url#{o}/search?q=#{search_request}"
      url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      response = RestClient.get "#{url}&oauth_token=#{TopazToken.return_token}"
      data = JSON.parse(response.body)
      data['data'].count.should == 1
    end
  end

  it "should return a 200 when requesting /ID endpoint on a draft object WITH OAuth" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      (RestClient.get "#@base_url#{o}/#{@object_array[i]}?oauth_token=#{TopazToken.return_token}").code.should == 200
      i = i+1
    end
  end

  it "should change draft state to deleted state" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      RestClient.put "#@base_url#{o}/#{@object_array[i]}?oauth_token=#{TopazToken.return_token}", {"metadata"=>{"state"=>"deleted"}}.to_json, :content_type => "application/json"
      i = i+1
    end
  end

  it "should return a 401 when requesting /ID endpoint on a deleted object" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      expect {RestClient.get "#@base_url#{o}/#{@object_array[i]}"}.to raise_error(RestClient::Unauthorized)
      i = i+1
    end
  end

  it "should return a 401 when requesting /objects endpoint on a draft object WITHOUT OAuth" do
    @legacy_id_array.length.should == 6
    @legacy_id_array[0].to_s.match(/..../).should be_true
    @legacy_id_array.each do |id|
      expect {RestClient.get "#{@base_url}objects/legacyId/#{id}"}.to raise_error(RestClient::Unauthorized)
    end
  end

  it "should return a 200 when requesting /objects endpoint on a draft object WITH OAuth" do
    @legacy_id_array.each do |id|
      res = RestClient.get "#{@base_url}objects/legacyId/#{id}?oauth_token=#{TopazToken.return_token}"
      res.code.should == 200
    end
  end

  it "should not return a result when searching by slug on a deleted object WITHOUT OAuth" do

    search_request = {
        "rules"=>[
            {
                "field"=>"metadata.slug",
                "condition"=>"term",
                "value"=>"media-qa-test-object-#@rand_num"
            }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>5,
        "sortBy"=>"system.createdAt",
        "sortOrder"=>"desc",
        "state" => "deleted"
    }.to_json

    %w(releases roles).each do |o|
      url = "#@base_url#{o}/search?q=#{search_request}"
      url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      response = RestClient.get url
      data = JSON.parse(response.body)
      data['data'].count.should == 0
    end
  end

  it "should return a 200 when requesting /ID endpoint on a deleted object WITH OAuth" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      (RestClient.get "#@base_url#{o}/#{@object_array[i]}?oauth_token=#{TopazToken.return_token}").code.should == 200
      i = i+1
    end
  end

  it "should clean up" do
    i = 0
    %w(releases people volumes shows episodes characters roles).each do |o|
      RestClient.delete "#@base_url#{o}/#{@object_array[i]}?oauth_token=#{TopazToken.return_token}"
      i = i+1
    end
  end

end








