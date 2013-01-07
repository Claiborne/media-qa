require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'pathconfig'

describe "game characters" do

  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = PathConfig.new
  end

  after(:each) do

  end

  it "should return valid game characters" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games/827005/characters.json?networkid=12"
   response.code.should eql(200)
   data = JSON.parse(response.body)
   data['characters'].should have_key('character')
  end

end
