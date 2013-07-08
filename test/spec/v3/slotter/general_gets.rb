require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'time'

include Assert

describe "V3 Slotter API -- GET /slotters" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/slotters?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  it "should return a 200 response code" do
    check_200(@response)
  end
  
  it "should return 100 entries (by default)" do
    @data.length.should == 100
  end
  
  %w(id timestamp principal name slug _rTimestamp).each do |key|
  it "should return a non-nil, non-blank #{key} value for all entries" do
    @data.each do |d|
      begin
        check_not_blank d[key]
        check_not_nil d[key]
      rescue => e
        raise e, e.message+". Non-nil or blank #{key} value here: \n #{d}"
      end
    end 
  end
  end

end
%w(id slug).each do |field|
describe "V3 Slotter API -- GET by /#{field.upcase}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_slotter.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/slotters?fresh=true"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
    begin
      @slotted = @data[0]
    rescue => e
      raise e, "Unable to set up this test case"
    end
    begin
      @response_id = RestClient.get "http://#{@config.options['baseurl']}/slotters/#{@slotted[field]}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end    
    @data_id = JSON.parse @response_id.body
  end
  
  it "should return a 200 response code" do
    check_200(@response)
  end
  
  it "should return the same data wehn seen in /slotters list" do
    begin
      @data_id.should == @slotted
    rescue => e
      time_diff = Time.parse(@data_id['_rTimestamp']) - Time.parse(@slotted['_rTimestamp'])
      raise e, e.message unless time_diff.abs < 10
    end
  end
  
end
end