require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

class GeneralImageSearch

  def self.networks
    {
    :startIndex => 0,
    :count => 200,
    :networks => 'gspy'
    }.to_json
  end

  def self.legacy_id_and_tags
    {
      :matchRule => "matchAll",
      :rules => [{
        :field => "legacyData.objectRelations",
        :condition => "is",
        :value => "110563"
        },
        {
        :field => "tags",
        :condition => "containsOne",
        :value => "gallery"
      }],
      :startIndex => 0,
      :count => 200,
      :fields => %w(metadata legacyData tags)
    }.to_json
  end

  def self.tags_contains_all
    {
    :matchRule => "matchAll",
    :rules => [
     {
       :field => "tags",
       :condition => "containsAll",
       :value => "screenshot, gallery"
     }],
    :startIndex => 0,
    :count => 200,
    :fields => %w(metadata tags)
    }.to_json
  end

  def self.range_and_sort_order(order)
    {
    :startIndex => 0,
    :count => 200,
    :sortBy => "metadata.publishDate",
    :sortOrder => order,
    :fields => %w(metadata),
    :fromDate => "2012-01-01T00:00:00-0000",
    :toDate => "2012-10-31T00:00:00-0000"
    }.to_json
  end

  def self.match_any
    {
    :matchRule => "matchAny",
    :rules => [
    {
      :field => "tags",
      :condition => "contains",
      :value => "screenshot"
    },
    {
      :field => "tags",
      :condition => "contains",
      :value => "article"
    }],
    :startIndex => 0,
    :count => 200,
    :fields => %w(metadata tags)
    }.to_json
  end

  def self.draft
    {
    :startIndex => 0,
    :count => 200,
    :states => 'draft',
    :fields => %w(metadata)
    }.to_json
  end

end

################################################################################

describe "V3 Image API -- GET Image Search Using #{GeneralImageSearch.networks}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.networks
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end

  it "should return 200 images" do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should only return published images" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should only return images in the gspy network" do
    @data['data'].each do |i|
      i['metadata']['networks'].include?('gspy').should be_true
    end
  end

end

################################################################################

describe "V3 Image API -- GET Image Search Using #{GeneralImageSearch.legacy_id_and_tags}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.legacy_id_and_tags
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end

  it "should return at least 25 images" do
    @data['count'].should > 24
    @data['data'].count.should > 24
  end

  it "should only return published images" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should only return images with the 110563 object attached" do
    @data['data'].each do |i|
      i['legacyData']['objectRelations'].include?(110563).should be_true
    end
  end

  it "should only return images tagged 'gallery'" do
    @data['data'].each do |i|
      tags_list = []
      i['tags'].each do |tags|
        tags_list << tags['slug']
      end
      tags_list.include?('gallery').should be_true
    end
  end

end

################################################################################

describe "V3 Image API -- GET Image Search Using #{GeneralImageSearch.tags_contains_all}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.tags_contains_all
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end

  it "should return 200 images" do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should only return published images" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should only return images tagged 'screenshot' AND 'gallery'" do
    @data['data'].each do |i|
      tags_list = []
      i['tags'].each do |tags|
        tags_list << tags['slug']
      end
      tags_list.include?('screenshot').should be_true
      tags_list.include?('gallery').should be_true
    end
  end

end

################################################################################

%w(desc asc).each do |order|
describe "V3 Image API -- GET Image Search Using #{GeneralImageSearch.range_and_sort_order(order)}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.range_and_sort_order(order)
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end

  it "should return 200 images" do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should only return published images" do
    @data['data'].each do |i|
      begin
      i['metadata']['state'].should == 'published'
      rescue
        i['imageId'].should == '4fbc208c708c5e43c2ded05a'
      end
    end
  end

  it "should return only images within the date range" do
    @data['data'].each do |i|
      i['metadata']['publishDate'].match(/2012-\d\d-\d\d/).should be_true
    end
  end

  if order == 'desc'
    it "should return images in descending order by publish date" do
      publish_dates = []
      @data['data'].each do |i|
        publish_dates << Time.parse(i['metadata']['publishDate'])
      end
      publish_dates.should == (publish_dates.sort {|x,y| y <=> x })
    end # end it
  else
    it "should return images in ascending order by publish date" do
      publish_dates = []
      @data['data'].each do |i|
        publish_dates << Time.parse(i['metadata']['publishDate'])
      end
      publish_dates.should == publish_dates.sort
    end # end it
  end

end end

################################################################################

describe "V3 Image API -- GET Image Search Using #{GeneralImageSearch.match_any}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.match_any
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  it "should return a hash with six indices" do
    check_indices(@data, 6)
  end

  it "should return 200 images" do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should only return published images" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should only return images tagged 'screenshot' OR 'article'" do
    @data['data'].each do |i|
      tags_list = []
      i['tags'].each do |tags|
        tags_list << tags['slug']
      end
      begin
        tags_list.include?('screenshot').should be_true
      rescue
        tags_list.include?('article').should be_true
      end
    end
  end

end

################################################################################

describe "V3 Image API -- GET Image Search _Without Auth_ Using #{GeneralImageSearch.draft}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/images/search?q="+GeneralImageSearch.draft
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return a 401" do
    expect {RestClient.get @url}.to raise_error(RestClient::Unauthorized)
  end

end