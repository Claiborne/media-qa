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
  
  def self.contains_all
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"tags.slug",
           "condition"=>"containsAll",
           "value"=>"ps3,xbox-360"
        },
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.contains_none
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"tags.slug",
           "condition"=>"containsNone",
           "value"=>"ps3,xbox-360"
        },
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.contains_one(n)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"tags.slug",
           "condition"=>"containsOne",
           "value"=>"ps3,xbox-360"
        },
      ],
      "startIndex"=>n.to_i,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.object_relations_contains(n)
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"objectRelations.platform",
           "condition"=>"containsOne",
           "value"=>"PlayStation 3,PC"
        },
        {
           "field"=>"objectRelations.platform",
           "condition"=>"containsNone",
           "value"=>"Xbox 360"
        },
      ],
      "startIndex"=>n.to_i,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.tag_contains
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"tags.slug",
           "condition"=>"containsAll",
           "value"=>"xbox-360,review"
        },
        {
           "field"=>"tags.slug",
           "condition"=>"containsNone",
           "value"=>"ps3,movies,comics,ds"
        },
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.category_contains
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"category",
           "condition"=>"containsAll",
           "value"=>"ign_all,xbox-360_all"
        },
        {
           "field"=>"category",
           "condition"=>"containsNone",
           "value"=>"ps3_all,ds_all,pc_all"
        },
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
  end
  
  def self.category_contains_one
    {
      "matchRule"=>"matchAll",
      "rules"=>[
        {
           "field"=>"category",
           "condition"=>"containsOne",
           "value"=>"ds_all"
        },
      ],
      "startIndex"=>0,
      "count"=>200,
      "states"=>"published",
      "networks"=>"ign"
    }.to_json
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

  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
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

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.contains_all}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.contains_all
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
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with tags 'ps3' and 'xbox-360' " do
    @data['data'].each do |d|
      tags = []
      d['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('ps3').should be_true
      tags.include?('xbox-360').should be_true
    end
  end
  
end

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.contains_none}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.contains_none
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
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only videos without tags 'ps3' or 'xbox-360' " do
    @data['data'].each do |d|
      tags = []
      d['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('ps3').should be_false
      tags.include?('xbox-360').should be_false
    end
  end
  
end

################################################################################

%w(0 200 400 600).each do |num|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.contains_one(num)}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.contains_one(num)
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
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end

  it "should return only videos with tags 'ps3' or 'xbox-360' " do
    @data['data'].each do |d|
      tags = []
      d['tags'].each do |t|
        tags << t['slug']
      end
      (tags.include?('ps3') ||  tags.include?('xbox-360')).should be_true
    
    end
  end
  
end
end

################################################################################

%w(0 200 400 600).each do |num|
describe "V3 Video API -- GET Search Using #{VideoGetSearch.object_relations_contains(num)}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.object_relations_contains(num)
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
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only videos with objectRelation.platforms values of 'PlayStation 3' or 'PC'" do
    @data['data'].each do |d|
      platforms = []
      d['objectRelations'].each do |o|
        platforms << o['platform']
      end
      (platforms.include?('PlayStation 3') || platforms.include?('PC')).should be_true
    end
  end
  
  it "should not return  videos with objectRelation.platforms values of 'Xbox 360'" do
    @data['data'].each do |d|
      platforms = []
      d['objectRelations'].each do |o|
        platforms << o['platform']
      end
      platforms.include?('Xbox 360').should be_false
    end
  end
end
end

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.tag_contains}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.tag_contains
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
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only videos with tags.slug values of 'xbox-360' and 'review'" do
    @data['data'].each do |d|
      tags = []
      d['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('xbox-360').should be_true
      tags.include?('review').should be_true
    end
  end
  
  it "should not return videos with tags.slug values of 'ps3', 'movies', 'comics', 'ds'" do
    @data['data'].each do |d|
      tags = []
      d['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('ps3').should be_false
      tags.include?('movies').should be_false
      tags.include?('comics').should be_false
      tags.include?('ds').should be_false
    end
  end
  
end

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.category_contains}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.category_contains
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
  
  it "should return at least 90 videos" do
    @data['data'].count.should > 89
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only videos with a category of 'ign_all' and 'xbox-360_all' " do
    @data['data'].each do |d|
      d['category'].include?('ign_all').should be_true
      d['category'].include?('xbox-360_all').should be_true
    end
  end
  
  it "should not return videos with a category of 'ps3_all', 'ds_all', or 'pc_all' " do
    @data['data'].each do |d|
      d['category'].include?('ps3_all').should be_false
      d['category'].include?('ds_all').should be_false
      d['category'].include?('pc_all').should be_false
    end
  end
  
end

################################################################################

describe "V3 Video API -- GET Search Using #{VideoGetSearch.category_contains_one}", :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/videos/search?q="+VideoGetSearch.category_contains_one
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
  end
  
  it "should return only published videos" do
    @data['data'].each do |d|
      d['metadata']['state'].should == "published"
    end
  end
  
  it "should return only videos with a network value of 'ign'" do
    @data['data'].each do |d|
      d['metadata']['networks'].include?('ign').should be_true
    end
  end
  
  it "should return only videos with a category of 'ds_all'" do
    @data['data'].each do |d|
      d['category'].include?('ds_all').should be_true
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