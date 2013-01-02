require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

# VIDEO SEARCH TESTS
# PLAYLIST SEARCH TESTS

class VideoGetSearch

  def self.is_classification(count)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
          "condition"=>"is",
          "field"=>"metadata.classification",
          "value"=>"Trailer"
        }
      ],
      "startIndex"=>count,
      "count"=>200,
      "networks"=>"ign",
      "states"=>"published"
    }.to_json
  end

  def self.is_classification_negative(count)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
          "condition"=>"is",
          "field"=>"metadata.classification",
          "value"=>"trailer"
        }
      ],
      "startIndex"=>count,
      "count"=>200,
      "states"=>"published"
    }.to_json
  end

  def self.networks_negative(count)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
          "condition"=>"is",
          "field"=>"metadata.classification",
          "value"=>"trailer"
        }
      ],
      "startIndex"=>count,
      "count"=>200,
      "networks"=>"Ign",
      "prime"=>"false",
      "states"=>"published"
    }.to_json
  end

  def self.tags(count)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
          "condition"=>"containsAll",
          "field"=>"tags",
          "value"=>"gameplay,xbox-360,playstation-3"
        }
      ],
      "startIndex"=>count,
      "count"=>200,
      "states"=>"published"
    }.to_json
  end

  def self.tags_negative(count)
    {
        "matchRule"=>"matchAll",
        "rules"=>[
            {
                "condition"=>"containsAll",
                "field"=>"tags",
                "value"=>"Gameplay,xbox-360,playstation-3"
            }
        ],
        "startIndex"=>count,
        "count"=>200,
        "states"=>"published"
    }.to_json
  end

  def self.video_series
    {
      "matchRule"=>"matchAny",
      "rules"=>[
        {
          "condition"=>"is",
          "field"=>"extra.videoSeries",
          "value"=>"Whats New"
        },
        {
          "condition"=>"is",
          "field"=>"extra.videoSeries",
          "value"=>"IGN NEWS"
        }
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published"
    }.to_json
  end

  def self.playlist_locale
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
          "condition"=>"is",
          "field"=>"metadata.locale",
          "value"=>"us"
        }
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published"
    }.to_json
  end

  def self.playlist_by_date_range
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
            "condition"=>"is",
            "field"=>"metadata.networks",
            "value"=>"ign"
        }],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "fromDate"=>"2011-01-01T00:00:00-0000",
      "toDate"=>"2011-12-31T00:00:00-0000"}.to_json
  end

end

# VIDEO SEARCH TESTS

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.is_classification(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.is_classification(count)
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  it "should return only videos with a metadata.classification value of 'Trailer'" do
    @data['data'].each do |v|
      v['metadata']['classification'].should == 'Trailer'
    end
  end

  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end

  it "should return only videos with a networl value of 'ign'" do
    @data['data'].each do |k|
      k['metadata']['networks'].each do |network|
        network.include?("ign").should be_true
      end
    end
  end

end end

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.is_classification_negative(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.is_classification_negative(count)
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

  it "should return 0 videos" do
    @data['data'].count.should == 0
    @data['count'].should == 0
  end

end end

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.networks_negative(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.networks_negative(count)
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

  it "should return 0 videos" do
    @data['data'].count.should == 0
    @data['count'].should == 0
  end

end end

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.tags(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.tags(count)
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end

  it "should return only videos tagged 'gameplay', 'xbox-360', and 'playstation-3'" do
    @data['data'].each do |v|
      tag_list = []
      v['tags'].count.should > 2
      v['tags'].each do |tags|
        tag_list << tags['slug']
      end
      tag_list.include?('gameplay').should be_true
      tag_list.include?('xbox-360').should be_true
      tag_list.include?('playstation-3').should be_true
    end
  end

end end

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.tags(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.tags(count)
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

  it "should return 200 videos" do
    @data['data'].count.should == 200
    @data['count'].should == 200
  end

  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end

  it "should return only videos tagged 'gameplay', 'xbox-360', and 'playstation-3'" do
    @data['data'].each do |v|
      tag_list = []
      v['tags'].count.should > 2
      v['tags'].each do |tags|
        tag_list << tags['slug']
      end
      tag_list.include?('gameplay').should be_true
      tag_list.include?('xbox-360').should be_true
      tag_list.include?('playstation-3').should be_true
    end
  end

end end

################################################################################

[0, 200, 400].each do |count|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.tags_negative(count)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.tags_negative(count)
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

  it "should return 0 videos" do
    @data['data'].count.should == 0
    @data['count'].should == 0
  end

end end

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.video_series}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.video_series
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

  it "should return at least 25 videos" do
    @data['data'].count.should > 24
    @data['count'].should > 24
  end

  it "should return only published videos" do
    @data['data'].each do |k|
      k['metadata']['state'].should == "published"
    end
  end

  it "should return only the video series asked for" do
    @data['data'].each do |v|
      series = v['extra']['videoSeries']
      begin
        series.should == 'Whats New'
      rescue
        series.should == 'IGN NEWS'
      end
    end
  end

end

# PLAYLIST SEARCH TESTS

################################################################################

describe "V3 Video API -- GET Search Playlists Using #{VideoGetSearch.playlist_locale}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search?q="+VideoGetSearch.playlist_locale
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

  it "should return at least 30 playlists" do
    @data['data'].count.should > 29
    @data['count'].should > 29
  end

  it "should return only published playlists" do
    @data['data'].each do |p|
      p['metadata']['state'].should == "published"
    end
  end

  it "should return only playlists with a metadata.locale value of 'us'" do
    @data['data'].each do |p|
      p['metadata']['locale'].should == 'us'
    end
  end

end

################################################################################

describe "V3 Video API -- GET Search Playlists Using #{VideoGetSearch.playlist_by_date_range}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/playlists/search?q="+VideoGetSearch.playlist_by_date_range
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

  it "should return at least 30 playlists" do
    @data['data'].count.should > 29
    @data['count'].should > 29
  end

  it "should return only published playlists" do
    @data['data'].each do |p|
      p['metadata']['state'].should == "published"
    end
  end

  it "should return only playlists within the date range" do
    @data['data'].each do |p|
      p['metadata']['publishDate'].match(/2011-\d\d-\d\d/).should be_true
    end
  end

end