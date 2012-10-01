require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Object API -- Releases Query Tests -- /releases?count=35&startIndex=35&metadata.state=published&metadata.region=UK" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases?count=35&startIndex=35&metadata.state=published&metadata.region=UK"
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
  
  it "should return a hash with five indices" do
    check_indices(@data, 5)
  end
  
  {'count'=>35,'startIndex'=>35,'endIndex'=>69,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end
  
  it "should return 25 releases" do
    @data['data'].length.should == 35
  end
  
  ['releaseId','metadata','content','system'].each do |data|
    it "should return #{data} data with a non-nil, not-blank value for all releases" do
      @data['data'].each do |release|
        release.has_key?(data).should be_true
        release[data].should_not be_nil
        release[data].to_s.length.should > 0
      end
    end
  end
  
  # metadata assertions
  
  it "should only return published releases" do
    @data['data'].each do |release|
      release['metadata']['state'].should == 'published'
    end
  end
  
  it "should only return releases of the UK region" do
    @data['data'].each do |release|
      release['metadata']['region'].should == 'UK'
    end
  end
  
=begin
  ['releaseDate','name','state','released','description','commonName','shortDescription','region','legacyId','game'].each do |data|
    it "should return metadata.#{data} data with a non-nil, not-blank value for all releases" do
      @data['data'].each do |data|
        data['metadata'].has_key?(data).should be_true
        data['metadata'][data].should_not be_nil
        data['metadata'][data].to_s.length.should > 0
      end
    end
  end
=end

  # content assertions
  
  # hardware assertions
  
  # system assertions

end

############################################################

[0, 45].each do |start_index|
describe "V3 Object API -- Releases Sort Order Tests -- /releases?count=200&startIndex=#{start_index}&metadata.state=published" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases?count=200&startIndex=#{start_index}&metadata.state=published"
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

  it "should return a hash with five indices" do
    check_indices(@data, 5)
  end

  {'count'=>200,'startIndex'=>start_index,'endIndex'=>199+start_index,'isMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return 200 releases" do
    @data['data'].length.should == 200
  end

  it "should only return published releases" do
    @data['data'].each do |release|
      release['metadata']['state'].should == 'published'
    end
  end

  it "should by default return releases in ascending order by releaseId" do
    ids = []
    @data['data'].each do |d|
      ids << d['releaseId']
    end
    ids.length.should == 200
    ids.should == ids.sort
  end

end
end

%w(asc desc).each do |order|
[75, 150].each do |start_index|
  describe "V3 Object API -- Releases Sort Order Tests -- /releases?count=200&startIndex=#{start_index}&metadata.state=published&sortBy=metadata.name&sortOrder=#{order}" do

    before(:all) do
      Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = Configuration.new
      @url = "http://#{@config.options['baseurl']}/releases?count=200&startIndex=#{start_index}&metadata.state=published&sortBy=metadata.name&sortOrder=#{order}"
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

    it "should return a hash with five indices" do
      check_indices(@data, 5)
    end

    {'count'=>200,'startIndex'=>start_index,'endIndex'=>199+start_index,'isMore'=>true}.each do |data,value|
      it "should return '#{data}' data with a value of #{value}" do
        @data.has_key?(data).should be_true
        @data[data].should_not be_nil
        @data[data].to_s.length.should > 0
        @data[data].should == value
      end
    end

    it "should return 200 releases" do
      @data['data'].length.should == 200
    end

    it "should only return published releases" do
      @data['data'].each do |release|
        release['metadata']['state'].should == 'published'
      end
    end

    it "should return releases in #{order} order by metadata.name" do
      names = []
      @data['data'].each do |d|
        if d['metadata']['name'].to_s.length > 0
          names << d['metadata']['name']
        end
      end
      if order == 'asc'
        names.length.should > 50
        names.should == names.sort
      else
        names.length.should > 50
        names.should == names.sort {|x,y| y <=> x }
      end

    end
  end
end
end

############################################################

# GAME, MOVIE, BOOK, SEASON
{'700186' => 'releases',
'85074' => 'releases',
'101233' => 'releases',
'63760' => 'releases',
'63022' => 'shows',
'14211921' => 'episodes',
'923183' => 'characters',
'913498' =>  'people',
'14273415' => 'volumes',
'14333681' => 'companies',
'850837' => 'hardware'
}.each do |id,type|
describe "V3 Object API -- GET For Unknown Release Objects -- /objects/legacyId/#{id}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/objects/legacyId/#{id}"
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

  end

  it "should return a response of 'endpoint: #{type}'" do
    @data['endpoint'].should == type
  end
end
end

############################################################

%w(releases shows episodes characters people volumes companies hardware).each do |type|
describe "V3 Object API -- GET For Unknown Release Objects -- /objects/legacyId/_ID_" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/#{type}?startIndex=#{Random.rand(65)}"
    @object_url = "http://#{@config.options['baseurl']}/objects/legacyId/"
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
    @ids = []
    @data['data'].each do |data|
      if data['metadata']['legacyId']
        @ids << data['metadata']['legacyId']
      end
    end
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do

  end

  it "should return a response of 'endpoint: #{type}'" do
    @ids.each do |id|
      response =  RestClient.get("#@object_url#{id}")
      data = JSON.parse(response.body)
      data['endpoint'].should == type
    end
  end
end
end

############################################################

%w(abc 347537459274).each do |id|
describe "V3 Object API -- GET For Unknown Release Objects -- /objects/legacyId/#{id}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/objects/legacyId/#{id}"
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 404" do
    expect { RestClient.get(@url) }.to raise_error(RestClient::ResourceNotFound)
  end

end
end