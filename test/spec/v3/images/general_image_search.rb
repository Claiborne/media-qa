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
       :value => "screenshot, shooter"
     }],
    :startIndex => 0,
    :count => 200,
    :fields => %w(metadata tags)
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

  it "should only return images tagged 'screenshot' AND 'shooter'" do
    @data['data'].each do |i|
      tags_list = []
      i['tags'].each do |tags|
        tags_list << tags['slug']
      end
      tags_list.include?('screenshot').should be_true
      tags_list.include?('shooter').should be_true
    end
  end

end