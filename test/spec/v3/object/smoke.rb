require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Object API -- General Smoke Tests -- [[[[[[[[[[[[[  URL   ]]]]]]]]]]]]", :smoke => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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
  
  it "should return a hash with five indices" do
    check_indices(@data, 5)
  end
  
  ['count','startIndex','endIndex','isMore','data'].each do |data|
    it "should return '#{data}' data with a non-nil value" do
      @data.has_key?('count').should be_true
      @data['count'].should_not be_nil
      @data['count'].to_s.length.should > 0
    end
  end
  
end