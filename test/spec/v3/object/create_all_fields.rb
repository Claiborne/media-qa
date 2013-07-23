require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken

=begin

describe "V3 Object API -- Create A Release With All Fields" do

  before(:all) do
    @token = return_topaz_token('objects')
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.stg['baseurl']}/releases?oauth_token=#{CreateSmokeHelperVars.return_token}"
    begin
      @response = RestClient.post @url, V3ObjCreateSmoke.create_valid_release, :content_type => "application/json"
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
    puts @data
  end

end

=end