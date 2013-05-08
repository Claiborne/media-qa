require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'; include Assert
require 'wiki_api_helper'; include WikiAPIHelper

describe "V3 Wiki API -- General Gets -- /wikis" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/wikis"
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

  include_examples "basic wiki API checks for each", 20, 0

end

describe "V3 Wiki API -- General Gets -- /wikis?count=200&startIndex=49", :prd => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/wikis?count=200&startIndex=49"
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

  include_examples "basic wiki API checks for each", 200, 49

end

describe "V3 Wiki API -- General Gets -- /wikis?count=100&startIndex=49", :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/wikis?count=100&startIndex=49"
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

  include_examples "basic wiki API checks for each", 100, 49

end

%w(?sortBy=createdDate ?sortBy=createdDate&sortOrder=desc) .each do |sort|
describe "V3 Wiki API -- General Gets -- /wikis#{sort}&count=75" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/wikis#{sort}&count=75"
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

  include_examples "basic wiki API checks for each", 75, 0

  it 'should return wikis in descending sort order by createdDate' do
    dates = []
    @data['data'].each do |w|
      dates << w['createdDate'] if w['createdDate'] > 0
    end
    sorted_dates = dates.sort { |x,y| y <=> x }
    sorted_dates.should == dates
  end

end end

describe "V3 Wiki API -- General Gets -- /wikis?sortBy=createdDate&sortOrder=asc&count=75" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/wikis?sortBy=createdDate&sortOrder=asc&count=75"
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

  include_examples "basic wiki API checks for each", 75, 0

  it 'should return wikis in ascending sort order by createdDate' do
    dates = []
    @data['data'].each do |w|
      dates << w['createdDate'] if w['createdDate'] > 0
    end
    sorted_dates = dates.sort
    sorted_dates.should == dates
  end

end

describe "V3 Wiki API -- Get By Wiki ID" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    url = "http://#{@config.options['baseurl']}/wikis?count=30"
    begin
      response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url)
    end
    data = JSON.parse(response.body)

    @ids = []
    data['data'].each do |w|
      @ids << w['wikiId']
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should have set up this test case correctly' do
    @ids.length.should == 30
  end

  it 'should get a wiki by ID' do
    @ids.each do |id|
      url = "http://#{@config.options['baseurl']}/wikis/#{id}"
      begin
        @response = RestClient.get url
      rescue => e
        raise Exception.new(e.message+" "+url)
      end
      @data = JSON.parse(@response.body)

      basic_wiki_api_checks @data

      @data['wikiId'].should == id

    end
  end

end

describe "V3 Wiki API -- Get By Slug" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    url = "http://#{@config.options['baseurl']}/wikis?count=30"
    begin
      response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url)
    end
    data = JSON.parse(response.body)

    @slugs = []
    data['data'].each do |w|
      @slugs << w['slug']
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should have set up this test case correctly' do
    @slugs.length.should == 30
  end

  it 'should get a wiki by ID' do
    @slugs.each do |slug|
      url = "http://#{@config.options['baseurl']}/wikis/slug/#{slug}"
      begin
        @response = RestClient.get url
      rescue => e
        raise Exception.new(e.message+" "+url)
      end
      @data = JSON.parse(@response.body)

      basic_wiki_api_checks @data

      @data['slug'].should == slug

    end
  end

end

describe "V3 Wiki API -- Get By objectId" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_wiki.yml"
    @config = PathConfig.new
    url = "http://#{@config.options['baseurl']}/wikis?count=30"
    begin
      response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url)
    end
    data = JSON.parse(response.body)

    @objects = []
    data['data'].each do |w|
      @objects << w['primaryObjectId'] if w['primaryObjectId']
    end

  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should have set up this test case correctly' do
    @objects.length.should > 5
  end

  it 'should get a wiki by ID' do
    @objects.each do |obj|
      url = "http://#{@config.options['baseurl']}/wikis/objectId/#{obj}"
      begin
        @response = RestClient.get url
      rescue => e
        raise Exception.new(e.message+" "+url)
      end
      @data = JSON.parse(@response.body)

      @data['data'].each do |w|
        w['relatedObjectIds'].include?(obj).should be_true
        basic_wiki_api_checks w
      end

    end
  end

end