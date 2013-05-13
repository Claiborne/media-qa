require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

%w(http://xbox360.ign.com/ http://xbox360.ign.com).each do |r|
describe "V3 Redirect API -- General Gets -- /redirects?from=#{r}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/redirects?from=#{r}"
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

  it "should return a 'from' value of 'http://xbox360.ign.com'" do
    @data[0]['from'].should == 'http://xbox360.ign.com'
  end

  it "should return an 'id' value that is a 24 character hash" do
    @data[0]['_id'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should return a 'to' value of 'http://www.ign.com/xbox-360'" do
    @data[0]['to'].should == 'http://www.ign.com/xbox-360'
  end

  it "should return a 'status' value of '301'" do
    @data[0]['status'].should == 301
  end

end end

describe "V3 Redirect API -- General Gets -- /redirects?from=ID", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/redirects/5181792eae71ffadba7a0355"
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

  it "should return a 'from' value of 'http://xbox360.ign.com'" do
    @data['from'].should == 'http://xbox360.ign.com'
  end

  it "should return an 'id' value that is a 24 character hash" do
    @data['_id'].should == '5181792eae71ffadba7a0355'
  end

  it "should return a 'to' value of 'http://www.ign.com/xbox-360'" do
    @data['to'].should == 'http://www.ign.com/xbox-360'
  end

  it "should return a 'status' value of '301'" do
    @data['status'].should == 301
  end

end

describe "V3 Redirect API -- General Gets -- /redirects?from=ID", :prd => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_redirect.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/redirects/5033bc74503b644d4bb12a65"
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

  it "should return a 'from' value of 'http://xbox360.ign.com'" do
    @data['from'].should == 'http://xbox360.ign.com'
  end

  it "should return an 'id' value that is a 24 character hash" do
    @data['_id'].should == '5033bc74503b644d4bb12a65'
  end

  it "should return a 'to' value of 'http://www.ign.com/xbox-360'" do
    @data['to'].should == 'http://www.ign.com/xbox-360'
  end

  it "should return a 'status' value of '301'" do
    @data['status'].should == 301
  end

end