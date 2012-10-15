require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'

##################################################################
# If a metadata.state other than published is requested and no oauth_token is supplied, the API will return 401

%w(releases people volumes shows episodes characters).each do |obj|
%w(draft deleted).each do |state|
describe "V3 Object API -- GET #{obj} with metadata.state=#{state} WITHOUT OAuth" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/#{obj}?metadata.state=#{state}&count=200"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should 401" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

end end end

##################################################################
# If no metadata.state parameter is passed in, or if the parameter is empty, the API defaults to published
# Invalid states in metadata.state are now ignored

%w(releases people volumes shows episodes characters).each do |obj|
["", ",", "fairy"].each do |state|
%w(0 200 400 600 800).each do |start|
describe "V3 Object API -- GET #{obj} with ?metadata.state=#{state}&count=200&startIndex=#{start} WITHOUT OAuth", :test => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/#{obj}?metadata.state=#{state}&count=200&startIndex=#{start}"
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

  it "should return 200 #{obj}" do
    @data['data'].count.should == 200
  end

  it "should only return published #{obj}" do
    @data['data'].each do |o|
      o['metadata']['state'].should == 'published'
    end
  end

  it "should return only embedded objects with state==published" do
    @data.to_s.match(/"state"=>"draft"/).should_not be_true
    @data.to_s.match(/"state"=>"deleted"/).should_not be_true
  end

end end end end

##################################################################
# If the requested object has metadata.state set to anything other than published, and no oauth_token is supplied by the client, the API will return 401
# This also applies to the /objects endpoint, even though it doesn't return full objects

#------> make a draft obj
#------> GET id & assert 401
#------> GET /object & assert 401

#------> change obj to del
#------> GET id & assert 401
#------> GET /object & assert 401

#------> clean up

#------> test embedds eeek







