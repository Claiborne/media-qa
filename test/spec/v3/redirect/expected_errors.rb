require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

describe "V3 Redirect API -- Add A Redirect Without a Token", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects"
    @body = {:from=>"http://here.com/foo/bar/should_fail",:to=>"http://there.com/should_fail",:status=>301}.to_json
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 401" do
    expect {RestClient.post @url, @body, :content_type => "application/json"}.to raise_error(RestClient::Unauthorized)
  end

end

describe "V3 Redirect API -- Add A Redirect Without a Valid Token", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=518197c3ae715c71349a1343"
    @body = {:from=>"http://here.com/foo/bar/should_fail",:to=>"http://there.com/should_fail",:status=>301}.to_json
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 401" do
    expect {RestClient.post @url, @body, :content_type => "application/json"}.to raise_error(RestClient::Unauthorized)
  end

end

describe "V3 Redirect API -- Add A Redirect Without a JSON Body", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=#{TopazToken.return_token}"
    @body = {:from=>"http://here.com/foo/bar/should_fail",:to=>"http://there.com/should_fail",:status=>301}
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 400" do
    expect {RestClient.post @url, @body, :content_type => "application/json"}.to raise_error(RestClient::BadRequest)
  end

end

describe "V3 Redirect API -- Add A Redirect With Invalid Content-Type Header", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    TopazToken.set_token('redirect')
    #@url = @url = "http://#{@config.options['baseurl']}/redirects?oauth_token=#{TopazToken.return_token}"
    @url = "http://apis.stg.ign.com/redirect/v3/redirects?oauth_token=#{TopazToken.return_token}"
    @body = {:from=>"http://here.com/foo/bar/should_fail",:to=>"http://there.com/should_fail",:status=>301}
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 400" do
    expect {RestClient.post @url, @body, :content_type => "application/xml"}.to raise_error(RestClient::BadRequest)
  end

end