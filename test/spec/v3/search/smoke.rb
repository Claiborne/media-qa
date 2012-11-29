require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

# No Query Param -- /search/
# No Query Param -- ?q and ?q=
# Smoke Query -- halo
# '+' vs '%20'
# Filter By Type
# Filter By Invalid Type

# No Query Param --/search/
%w(search).each do |q|
describe "V3 Search API -- No Query Param '#{q}'" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/#{q}"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 400 response code" do
    expect {RestClient.get @url}.to raise_error(RestClient::BadRequest)
  end

end end

# No Query Param -- ?q and ?q=
%w(search?q search?q=).each do |q|
describe "V3 Search API -- No Query Param '#{q}'" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/#{q}"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 200 response code" do
    check_200(@response)
  end

  it "should return 0 results" do
    puts @data['data']
    @data['data'].length.should == 0
  end

  it "should return a count value of 0" do
    @data['count'].should == 0
  end

  it "should return a startIndex value of 0" do
    @data['startIndex'].should == 0
  end

  it "should return an endIndex value of false" do
    @data['isMore'].should be_false
  end

  it "should return an total value of 0" do
    @data['total'].should == 0
  end

  it "should return a maxScore value of null" do
    @data['maxScore'].should == nil
  end

end end

# Smoke Query -- halo
['halo','halo 2','halo 3','halo 4'].each do |q|
describe "V3 Search API -- Smoke Query '#{q}'" do

  @count = 200

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @count = 200
    @url = "http://#{@config.options['baseurl']}/search?q=#{q}&count=#@count&highlight=true".gsub(" ","+")
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 200 response code" do
    check_200(@response)
  end

  it "should return #@count results" do
    @data['data'].length.should == @count
  end

  it "should return a count value of #@count" do
    @data['count'].should == @count
  end

  it "should return a startIndex value of 0" do
    @data['startIndex'].should == 0
  end

  it "should return an endIndex value of #{@count-1}" do
    @data['endIndex'].should == @count-1
  end

  it "should return an isMore value of true" do
    @data['isMore'].should be_true
  end

  it "should return a total value of at least 120,000 unless query is just halo" do
    if q == 'halo'
      @data['total'].should > 20000
    else
      @data['total'].should > 119999
    end
  end

  it "should return a maxScore between 5 and 7" do
    (5 < @data['maxScore']).should be_true
    (7 >  @data['maxScore']).should be_true
  end

  it "should return at least one article, video and object in the first 20 results" do
    types = []
    20.times do |i|
      types << @data['data'][i]['type']
    end
    types.include?('article').should be_true
    types.include?('video').should be_true
    types.include?('object').should be_true
  end

end end

# '+' vs '%20'
describe "V3 Search API -- '+' vs '%20'" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @count = 200
    @url = "http://#{@config.options['baseurl']}/search?q=halo+2"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 200 response code" do
    check_200(@response)
  end

  it "should return the same results" do
    url = "http://#{@config.options['baseurl']}/search?q=halo%202"
    begin
      response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url)
    end
    data = JSON.parse @response.body
    @data.should == data
  end

end

# Filter By Type
%w(object article video wiki).each do |type|
describe "V3 Search API -- Filter By Type #{type}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @count = 200
    @url = "http://#{@config.options['baseurl']}/search?q=halo&type=#{type}&count=200"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 200 response code" do
    check_200(@response)
  end

  it "should return 200 results" do
    @data['count'].should == 200
    @data['data'].length.should == 200
  end

  it "should only return results of type #{type}" do
    @data['data'].each do |result|
      result['type'].should == type
    end
  end

end end

# Filter By Invalid Type
describe "V3 Search API -- Filter By Type invalid" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = Configuration.new
    @count = 200
    @url = "http://#{@config.options['baseurl']}/search?q=halo&type=invalid&count=200"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 200 response code" do
    check_200(@response)
  end

  it "should return 0 results" do
    @data['count'].should == 0
    @data['data'].length.should == 0
  end

end