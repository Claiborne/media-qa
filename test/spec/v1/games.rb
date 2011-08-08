require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'

describe "games" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json"    
   response.code.should eql(200)
   data = JSON.parse(response.body)   

  end

end
