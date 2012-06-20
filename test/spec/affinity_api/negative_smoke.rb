require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'

require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'

def queries_that_400
  %w(?do=recommend&id=110563
  ?do=recommend&id=4433&count=3
  ?do=recommend&id=999999999999999999999&count=10
  ?do=recommend&id=abc&count=10
  ?do=recommend&id=714955&count=99999999999999999
  ?do=recommend&id=714955&count=abc
  ?do=affinity&id=110563
  ?do=affinity&id=4433&count=3
  ?do=affinity&id=999999999999999999999&count=10
  ?do=affinity&id=abc&count=10
  ?do=affinity&id=714955&count=99999999999999999
  ?do=affinity&id=714955&count=abc
  ?do=butt&id=117913&count=500)
end

def affinity_api_neg_assertions

  it "should return 'Type' data with a value of 'BadRequest'" do
    @data.has_key?('Type').should be_true
    @data['Type'].should == 'BadRequest'
  end

  it "should return 'Code' data with a value of 400" do
    @data.has_key?('Code').should be_true
    @data['Code'].should == 400
  end

end

queries_that_400.each do |q|
describe "Affinity API -- #{q}", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/affinity_api.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}#{q}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response.to_s)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  affinity_api_neg_assertions

  affinity_api_response_time(10)

end
end