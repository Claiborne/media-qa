require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Slotter API -- GET /slotters" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/slotters"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  it "should return a 200 response code" do
    puts @url
    check_200(@response)
  end
  
  it "should return 100 entries (by default)" do
    @data.length.should == 100
  end
  
end
