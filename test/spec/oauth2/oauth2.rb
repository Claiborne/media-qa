require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'mongo'

describe "oauth2" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/oauth2.yml"
    @config = Configuration.new
 
    @conn = Mongo::Connection.new
    @db = @conn.db('oauth2')
   # @db.drop_collections 
  end

  after(:each) do

  end

  it "should return valid articles" do
  # response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles"
  # response.code.should eql(200)
  # data = JSON.parse(response.body)
  end

end
