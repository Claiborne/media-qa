require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

class GeneralAlbumSearch

  def self.networks
    {
      :startIndex => 0,
      :count => 200,
      :networks => 'ign'
    }.to_json
  end

  def self.locale
    {
      :matchRule => "matchAll",
      :rules => [{
         :field => "categoryLocales",
         :condition => "contains",
         :value => "uk"
       }],
      :startIndex => 0,
      :count => 200,
      :fields => %w(metadata categoryLocales)
    }.to_json
  end

  def self.tags_contains_all
    {
      :matchRule => "matchAll",
      :rules => [
        {
          :field => "tags",
          :condition => "containsAll",
          :value => "game, xbox-360"
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
    :states => 'published',
    :fields => %w(metadata),
    :fromDate => "2012-01-01T00:00:00-0000",
    :toDate => "2012-10-31T00:00:00-0000"
    }.to_json
  end

end

################################################################################

describe "V3 Image API -- GET Album Search Using #{GeneralAlbumSearch.networks}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/albums/search?q="+GeneralAlbumSearch.networks+"&fresh=true"
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

  it "should return 200 albums", :prd => true do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should return at least one album", :stg => true do
    @data['count'].should > 0
    @data['data'].count.should > 0
  end

  it "should only return published albums" do
    @data['data'].each do |a|
      a['metadata']['state'].should == 'published'
    end
  end

  it "should only return albums in the ign network" do
    @data['data'].each do |a|
      a['metadata']['networks'].include?('ign').should be_true
    end
  end

end

################################################################################

describe "V3 Image API -- GET Album Search Using #{GeneralAlbumSearch.locale}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/albums/search?q="+GeneralAlbumSearch.locale+"&fresh=true"
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

  it "should return 200 albums", :prd => true do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should return at least one album", :stg => true do
    @data['count'].should > 0
    @data['data'].count.should > 0
  end

  it "should only return published albums" do
    o = 0
    @data['data'].each do |a|
      a['metadata']['state'].should == 'published'
    end
  end

  it "should only return albums with a categoryLocales value containing 'uk'" do
    @data['data'].each do |a|
      a['categoryLocales'].include?('uk').should be_true
    end
  end

end

################################################################################

describe "V3 Image API -- GET Album Search Using #{GeneralAlbumSearch.tags_contains_all}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/albums/search?q="+GeneralAlbumSearch.tags_contains_all+"&fresh=true"
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

  it "should return at least 50 albums", :prd => true do
    @data['count'].should > 49
    @data['data'].count.should > 49
  end

  it "should return at least one album", :stg => true do
    @data['count'].should > 0
    @data['data'].count.should > 0
  end

  it "should only return published albums" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should only return albums tagged 'game' AND 'xbox-360'" do
    @data['data'].each do |i|
      tags_list = []
      i['tags'].each do |tags|
        tags_list << tags['slug']
      end
      tags_list.include?('game').should be_true
      tags_list.include?('xbox-360').should be_true
    end
  end

end

################################################################################

%w(desc asc).each do |order|
describe "V3 Image API -- GET Albums Search Using #{GeneralAlbumSearch.range_and_sort_order(order)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/albums/search?q="+GeneralAlbumSearch.range_and_sort_order(order)+"&fresh=true"
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

  it "should return 200 albums", :prd => true do
    @data['count'].should == 200
    @data['data'].count.should == 200
  end

  it "should return at least one album", :stg => true do
    @data['count'].should > 0
    @data['data'].count.should > 0
  end

  it "should only return published albums" do
    @data['data'].each do |i|
      i['metadata']['state'].should == 'published'
    end
  end

  it "should return only albums within the date range" do
    @data['data'].each do |i|
      i['metadata']['publishDate'].match(/2012-\d\d-\d\d/).should be_true
    end
  end

  if order == 'desc'
    it "should return albums in descending order by publish date" do
      publish_dates = []
      @data['data'].each do |i|
        publish_dates << Time.parse(i['metadata']['publishDate'])
      end
      publish_dates.should == (publish_dates.sort {|x,y| y <=> x })
    end # end it
  else
    it "should return albums in ascending order by publish date" do
      publish_dates = []
      @data['data'].each do |i|
        publish_dates << Time.parse(i['metadata']['publishDate'])
      end
      publish_dates.should == publish_dates.sort
    end # end it
  end

end end