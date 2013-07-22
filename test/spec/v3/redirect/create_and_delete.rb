require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

module RedirectHelper

  @rand_num = Random.rand(100000000000)

  class Vars
    @@id

    def self.set_id(id)
      @@id = id
    end

    def self.get_id
      @@id
    end
  end

  def self.new_redirect
    {
    :from=>"http://here.com/foo/bar/#{@rand_num}",
    :to=>"http://there.com/#{@rand_num}",
    :status=>301
    }
  end

end

describe "V3 Redirect API -- Create A Redirect", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, (RedirectHelper.new_redirect).to_json, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 201" do
    RedirectHelper::Vars.set_id @data['_id']
    @response.code.should == 201
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return an id that is a 24-character hash" do
    @data['_id'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return the appropriate 'from' value" do
    @data['from'].should == RedirectHelper.new_redirect[:from]
  end

  it "should return the appropriate 'to' value" do
    @data['to'].should == RedirectHelper.new_redirect[:to]
  end

  it "should return the appropriate 'status' value" do
    @data['status'].should == RedirectHelper.new_redirect[:status]
  end

end

describe "V3 Redirect API -- Confirm Add A Redirect Using '/ID'", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects/#{RedirectHelper::Vars.get_id}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects/#{RedirectHelper::Vars.get_id}?fresh=true"
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

  it "should return an id that is a 24-character hash" do
    @data['_id'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return the appropriate 'from' value" do
    @data['from'].should == RedirectHelper.new_redirect[:from]
  end

  it "should return the appropriate 'to' value" do
    @data['to'].should == RedirectHelper.new_redirect[:to]
  end

  it "should return the appropriate 'status' value" do
    @data['status'].should == RedirectHelper.new_redirect[:status]
  end

end

describe "V3 Redirect API -- Confirm Add A Redirect Using '?from='", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?from=#{RedirectHelper.new_redirect[:from]}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?from=#{RedirectHelper.new_redirect[:from]}?fresh=true"
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

  it "should return an id that is a 24-character hash" do
    @data[0]['_id'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return the appropriate 'from' value" do
    @data[0]['from'].should == RedirectHelper.new_redirect[:from]
  end

  it "should return the appropriate 'to' value" do
    @data[0]['to'].should == RedirectHelper.new_redirect[:to]
  end

  it "should return the appropriate 'status' value" do
    @data[0]['status'].should == RedirectHelper.new_redirect[:status]
    sleep 2
  end

end

describe "V3 Redirect API -- Add A Duplicate Redirect", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=#{TopazToken.return_token}"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 409" do
    expect {RestClient.post @url, (RedirectHelper.new_redirect).to_json, :content_type => "application/json"}.to raise_error(RestClient::Conflict)
  end

end

describe "V3 Redirect API -- Add A Circular Redirect", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=#{TopazToken.return_token}"
    @circ = {:from=>RedirectHelper.new_redirect[:to].to_s,:to=>RedirectHelper.new_redirect[:from].to_s}.to_json
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 409" do
    expect {RestClient.post @url, @circ, :content_type => "application/json"}.to raise_error(RestClient::Conflict)
  end

end

describe "V3 Redirect API -- Delete A Redirect", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    #@url = @url = "http://#{@config.options['baseurl']}/redirects/#{RedirectHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects/#{RedirectHelper::Vars.get_id}?oauth_token=#{TopazToken.return_token}"
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

  it "should return true" do
    @data['result'].should be_true
    sleep 2
  end

end

describe "V3 Redirect API -- Confirm Delete A Redirect Using '/ID'", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects/#{RedirectHelper::Vars.get_id}?fresh=true"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects/#{RedirectHelper::Vars.get_id}?fresh=true"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 404" do
    expect {RestClient.get @url}.to raise_error(RestClient::ResourceNotFound)
  end

end

describe "V3 Redirect API -- Confirm Delete A Redirect Using '?from='", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?from=#{RedirectHelper.new_redirect[:from]}&fresh=true"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?from=#{RedirectHelper.new_redirect[:from]}&fresh=true"
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

  it "should return a blank array" do
    @data.should == []
  end

end