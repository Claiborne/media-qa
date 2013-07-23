require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'object_api_helper'
require 'time'

include Assert
include ObjectApiHelper

class Me3GameId
  
  @me3_game_id = get_game_id('mass-effect-3')
  
  def self.me3_game_id
    @me3_game_id
  end

  @dark_knight_legacy_id = get_movie_legacy_id('the-dark-knight-rises')

  def self.dark_knight_legacy_id
    @dark_knight_legacy_id
  end

  
end

########################### BEGIN REQUEST BODY METHODS #############################

class GeneralGetSearchHelperMethods

  #Search /releases

  def self.release_search_smoke
    {
      "rules"=>[
        {
          "field"=>"hardware.platform.metadata.slug",
          "condition"=>"term",
          "value"=>"xbox-360"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>75,
      "sortBy"=>"metadata.releaseDate.date",
      "sortOrder"=>"desc",
      "states"=>["published"],
      "regions"=>["US"]
    }.to_json
  end

  def self.reviewed_games
    {
      "rules"=>[
        {
          "field"=>"network.ign.review.score",
          "condition"=>"exists",
          "value"=>""
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>75,
      "sortBy"=>"network.ign.review.score",
      "sortOrder"=>"desc",
      "states"=>["published"]
    }.to_json
  end

  def self.mass_effect_3_releases_by_game_id
    {
      "rules"=>[
        {
          "field"=>"metadata.game.gameId",
          "condition"=>"term",
          "value"=>"#{Me3GameId.me3_game_id}"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>10,
      "states"=>["published"]
    }.to_json
  end

  def self.mass_effect_3_releases_by_game_legacyid
    {
      "rules"=>[
        {
          "field"=>"metadata.legacyId",
          "condition"=>"term",
          "value"=>"110694"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>10,
      "states"=>["published"]
    }.to_json
  end

  def self.mass_effect_3_releases_by_game_slug
    {
      "rules"=>[
        {
          "field"=>"metadata.game.metadata.slug",
          "condition"=>"term",
          "value"=>"mass-effect-3"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>10,
      "states"=>["published"]
    }.to_json
  end

  def self.bioware_games_by_dev_name
    {
      "rules"=>[
        {
          "field"=>"companies.developers.metadata.name",
          "condition"=>"term",
          "value"=>"bioware"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>25,
      "states"=>["published"]
    }.to_json
  end

  def self.bioware_games_by_dev_legacyid
    {
      "rules"=>[
        {
          "field"=>"companies.developers.metadata.legacyId",
          "condition"=>"term",
          "value"=>"26717"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>25,
      "states"=>["published"]
    }.to_json
  end

  def self.release_by_is_released(is_released)
    {
      "rules"=>[
        {
          "field"=>"metadata.releaseDate.status",
          "condition"=>"term",
          "value"=>is_released.to_s
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>0,
      "count"=>100,
      "states"=>["published"]
    }.to_json
  end

  def self.release_by_popularity
    {
        "rules"=>[
            {
                "field"=>"metadata.releaseDate.status",
                "condition"=>"term",
                "value"=>"released"
            }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>100,
        "sortBy"=>"metadata.popularity",
        "sortOrder"=>"desc",
        "states"=>["published"]
    }.to_json
  end

  def self.release_pagination(count,start_index)
    {
      "rules"=>[
        {
          "field"=>"hardware.platform.metadata.slug",
          "condition"=>"term",
          "value"=>"xbox-360"
        }
      ],
      "matchRule"=>"matchAll",
      "startIndex"=>start_index.to_i,
      "count"=>count.to_i,
      "sortBy"=>"metadata.releaseDate.date",
      "sortOrder"=>"desc",
      "states"=>["published"],
      "regions"=>["US"]
    }.to_json
  end

  def self.search_using_condition_in(val,field,cond)
    {
        "rules"=>[
        {
            "field"=>field.to_s,
            "condition"=>cond.to_s,
            "value"=>val.to_s}
    ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>60,
        "sortBy"=>"metadata.popularity",
        "sortOrder"=>"desc",
        "states"=>["published"],
        "regions"=>["US"]
    }.to_json
  end

    def self.search_movies_by_type(type)
      {
          "rules"=>[
              {
                  "field"=>"metadata.movie.metadata.type",
                  "condition"=>"term",
                  "value"=>type.to_s
              }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>55
      }.to_json
    end

    def self.search_movie_by_legacy_id(id)
      {
          "rules"=>[
              {
                  "field"=>"metadata.legacyId",
                  "condition"=>"term",
                  "value"=>id
              }
          ]
      }.to_json
    end

    def self.search_movie_by_legacy_id_embedded(id)
      {
          "rules"=>[
              {
                  "field"=>"metadata.movie.metadata.legacyId",
                  "condition"=>"term",
                  "value"=>id
              }
          ]
      }.to_json
    end

    def self.search_movie_by_genre(genre)
      {
          "rules"=>[
              {
                  "field"=>"metadata.movie.movieId",
                  "condition"=>"exists",
                  "value"=>""
              },
              {
                  "field"=>"content.primaryGenre.metadata.slug",
                  "condition"=>"term",
                  "value"=>genre
              }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>200
      }.to_json
    end

    def self.search_books
      {
        "rules"=>[
        {
            "field"=>"metadata.book.bookId",
            "condition"=>"exists",
            "value"=>""
        }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>200
      }.to_json
    end

    def self.search_books_by_legacy_id
      {
          "rules"=>[
              {
                  "field"=>"metadata.book.metadata.legacyId",
                  "condition"=>"term",
                  "value"=>138260
              }
          ]
      }.to_json
    end

    def self.search_books_by_slug
      {
          "rules"=>[
              {
                  "field"=>"metadata.book.metadata.slug",
                  "condition"=>"term",
                  "value"=>"batman-the-dark-knight-2011-11"
              }
          ]
      }.to_json
    end

    def self.search_books_by_volume
      {
          "rules"=>[
              {
                  "field"=>"metadata.book.bookId",
                  "condition"=>"exists",
                  "value"=>""
              },
              {
                  "field"=>"metadata.book.metadata.volume.metadata.legacyId",
                  "condition"=>"term",
                  "value"=>110600
              }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>200
      }.to_json
    end

    def self.search_volumes
      {
          "rules"=>[
              {
                  "field"=>"metadata.book.metadata.volume.volumeId",
                  "condition"=>"exists",
                  "value"=>""
              }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>200
      }.to_json
    end

    # Search /roles

    def self.search_role_roletype
      {
        "rules"=>[
          {
              "field"=>"metadata.roleType.metadata.slug",
              "condition"=>"term",
              "value"=>"director"
          }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>200
      }.to_json
    end

    def self.search_role_person
      {
        "rules"=>[
          {
              "field"=>"metadata.person.metadata.legacyId",
              "condition"=>"term",
              "value"=>913626
          }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>200
      }.to_json
    end

    def self.search_role_movie_exists
      {
          "rules"=>[
              {
                  "field"=>"metadata.movie.movieId",
                  "condition"=>"exists",
                  "value"=>""
              }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>200
      }.to_json
    end

  def self.search_role_character
    {
        "rules"=>[
            {
                "field"=>"metadata.character.metadata.slug",
                "condition"=>"term",
                "value"=>"batman"
            }
        ],
        "matchRule"=>"matchAll",
        "startIndex"=>0,
        "count"=>200
    }.to_json
  end

  def self.search_without_state_filter(index)
    {
    "rules"=>[
      {
          "field"=>"metadata.legacyId",
      "condition"=>"exists",
      "value"=>""
      }
    ],
      "matchRule"=>"matchAll",
      "startIndex"=>index.to_i,
      "count"=>200,
      "sortBy"=>"system.createdAt",
      "sortOrder"=>"desc"
    }.to_json
  end

end

  ########################### BEGIN ASSERTION METHODS #############################

  shared_examples "v3 object general get search common checks" do |data_count|

    it "should return a hash with five indices" do
      check_indices(@data, 6)
    end

    it "should return 'count' data with a non-nil, non-blank value" do
      @data.has_key?('count').should be_true
      @data['count'].should_not be_nil
      @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'count' data with a value of #{data_count}" do
      @data['count'].should == data_count
    end

    it "should return 'startIndex' data with a non-nil, non-blank value" do
      @data.has_key?('startIndex').should be_true
      @data['startIndex'].should_not be_nil
      @data['startIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'startIndex' data with a value of 0" do
      @data['startIndex'].should == 0
    end

    it "should return 'endIndex' data with a non-nil, non-blank value" do
      @data.has_key?('endIndex').should be_true
      @data['endIndex'].should_not be_nil
      @data['endIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'endIndex' data with a value of #{data_count-1}" do
      @data['endIndex'].should == data_count-1
    end

    it "should return 'isMore' data with a non-nil, non-blank value" do
      @data.has_key?('isMore').should be_true
      @data['isMore'].should_not be_nil
      @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'isMore' data with a value of true" do
      @data['isMore'].should == true
    end

    it "should return 'total' data with a non-nil, non-blank value" do
      @data.has_key?('total').should be_true
      @data['total'].should_not be_nil
      @data['total'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'total' data with a value of #{data_count}" do
      @data['total'].should > data_count
    end

    it "should return 'data' with a non-nil, non-blank value" do
      @data.has_key?('data').should be_true
      @data['data'].should_not be_nil
      @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end

    it "should return 'data' with an array length of #{data_count}" do
      @data['data'].length.should == data_count
    end

  end

  shared_examples "v3 object general get search check Id" do |id|

    it "should return at least one release" do
      @data['data'].count.should > 0
    end

    it "should return a #{id} value that is a 24-character hash for all releases" do
      @data['data'].each do |release|
        release[id].match(/^[0-9a-f]{24,32}$/).should be_true
      end
    end
  end


############################ BEGIN SPEC #################################### 


describe "V3 Object API -- GET Search for Published 360 Releases: #{GeneralGetSearchHelperMethods.release_search_smoke}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.release_search_smoke.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 75

  it_behaves_like "v3 object general get search check Id", 'releaseId'
  
  it "should return a releaseId value that is a 24-character hash for all releases" do
    @data['data'].each do |release|
      release['releaseId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end
  
  it "should only return releases with a hardware.platform.metadata.slug value of 'xbox-360'" do
    @data['data'].each do |release| 
      release['hardware']['platform']['metadata']['slug'].should == 'xbox-360'
    end 
  end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
  it "should only return releases with a metadata.region value of 'US'" do
    @data['data'].each do |release| 
      release['metadata']['region'].should == 'US'
    end
  end

  it "should return release in desc metadata.releaseDate.date order" do
    date = []
    @data['data'].each do |release|
      date << Time.parse(release['metadata']['releaseDate']['date'])
    end

    date.sort {|x,y| y <=> x }.should == date
  end
  
end

################################################################ 

describe "V3 Object API -- GET Search for Reviewed Releases: #{GeneralGetSearchHelperMethods.reviewed_games}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.reviewed_games.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 75

  it_behaves_like "v3 object general get search check Id", 'releaseId'
  
  it "should return network.ign.review.score data with a numeric value for all releases" do
    @data['data'].each do |release|
      release['network']['ign']['review']['score'].to_s.delete('^0-9').length.should > 0
    end
  end
  
  it "should return releases in descending network.ign.review.score order" do
      scores = []
      @data['data'].each do |release|
        scores << release['network']['ign']['review']['score']
      end  
      scores.sort{|x,y| y <=> x }.should == scores
    end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
  
end

################################################################ 

{GeneralGetSearchHelperMethods.mass_effect_3_releases_by_game_id=>'GameId',GeneralGetSearchHelperMethods.mass_effect_3_releases_by_game_legacyid=>'LegacyId',GeneralGetSearchHelperMethods.mass_effect_3_releases_by_game_slug=>'Game Slug'}.each do |request_body,description|
  describe "V3 Object API -- GET Search for Releases by #{description} using: #{request_body}" do

    before(:all) do
      PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = PathConfig.new
      @url = "http://#{@config.options['baseurl']}/releases/search?q="+request_body.to_s+"&fresh=true"
      @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

    after(:all) do

    end

    it "should return at least 4 releases" do
      @data['data'].count.should > 3  
    end

    it_behaves_like "v3 object general get search check Id", 'releaseId'
    
    it "should only return releases with a metadata.game.gameId value of '#{Me3GameId.me3_game_id}'" do
      @data['data'].each do |release|
        release['metadata']['game']['gameId'].should == Me3GameId.me3_game_id
      end
    end
    
    if description=='LegacyId'
    it "should only return releases with a metadata.legacyId value of '110694" do
      @data['data'].each do |release|
        release['metadata']['legacyId'].should == 110694
      end
    end
    end
    
    it "should only return releases with a metadata.game.slug value of 'mass-effect-3" do
      @data['data'].each do |release|
        release['metadata']['game']['metadata']['slug'].should == 'mass-effect-3'
      end
    end

  end
end
################################################################ 

describe "V3 Object API -- GET Search for Bioware Releases By Dev Name: #{GeneralGetSearchHelperMethods.bioware_games_by_dev_name}" do
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.bioware_games_by_dev_name.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 25

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should only return companies.developers.metadata.name data with a value of 'BioWare'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['name']
      end
      developers.to_s.downcase.match(/bioware/).should be_true
    end
  end

  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
end

################################################################ 

describe "V3 Object API -- GET Search for Bioware Releases By Dev legacyId: #{GeneralGetSearchHelperMethods.bioware_games_by_dev_legacyid}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.bioware_games_by_dev_legacyid.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 25

  it_behaves_like "v3 object general get search check Id", 'releaseId'
  
  it "should only return companies.developers.metadata.name data with a value of 'BioWare'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['name']
      end
      developers.include?('BioWare').should be_true
    end
  end
  
  it "should only return companies.developers.metadata.legacyId data with a value of '26717'" do
    @data['data'].each do |release|
      developers = []
      release['companies']['developers'].each do |dev|
        developers << dev['metadata']['legacyId']
      end
      developers.include?(26717).should be_true
    end
  end
  
  it "should only return releases with a metadata.state value of 'published'" do
    @data['data'].each do |release| 
      release['metadata']['state'].should == 'published'
    end    
  end
  
end

################################################################
['released','unreleased','canceled'].each do |is_released|
describe "V3 Object API -- GET Search for Releases by status==#{is_released}: #{GeneralGetSearchHelperMethods.release_by_is_released(is_released)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.release_by_is_released(is_released).to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
  
  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 100
  
  it "should only return releases with a metadata.releaseDate.status value of #{is_released}" do
    @data['data'].each do |release|
      release['metadata']['releaseDate']['status'].should == is_released  
    end  
  end
  
end
end

################################################################ 

describe "V3 Object API -- GET Search - Test Pagination Using: #{GeneralGetSearchHelperMethods.release_pagination(11,0)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.release_pagination(11,0).to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin 
       @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
    
    @eleventh_entry = @data['data'][10]['releaseId']
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
   
  it "should pass basic pagination check" do
    begin 
      @url2 = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.release_pagination(10,10).to_s+"&fresh=true"
      @url2 = @url2.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      @response = RestClient.get @url2
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @page_data = JSON.parse(@response.body)
    begin
      @page_data['data'][0]['releaseId'].should == @eleventh_entry
    rescue => e
      first_11 = []
      second_10 = []
      @data['data'].each do |d|
        first_11 << d['releaseId']
      end
      @page_data['data'].each do |d|
        second_10 << d['releaseId']
      end
      Exception.new(e.message+"\nFIRST 11:\n#{first_11}\nSECOND 10:\n#{second_10}")
    end
  end

end

################################################################

["3ds,nds","xbox-360,pc,ps3","ps,ps2"].each do |in_val|
describe "V3 Object API -- GET Search - Search Using Condition 'in' using: #{GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'hardware.platform.metadata.slug','in')}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'hardware.platform.metadata.slug',"in").to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 60

  it "should return only releases with a hardware.platform.metadata.slug value that includes the following: #{in_val}" do
    @data['data'].each do |release|
      in_val.split(",").include?(release['hardware']['platform']['metadata']['slug']).should be_true
    end
  end

  in_val.split(",").each do |val|
    it "should return at least one release with a hardware.platform.metadata.slug value of #{val}" do
      platform_data = []
      @data['data'].each do |release|
        platform_data << release['hardware']['platform']['metadata']['slug']
      end
      platform_data.include?(val).should be_true
    end
  end

end
end

################################################################

["rpg,action","action","rpg,adventure,fighting"].each do |in_val|
  describe "V3 Object API -- GET Search - Search Using Condition 'in' using: #{GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'content.primaryGenre.metadata.slug','in')}" do

    before(:all) do
      PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = PathConfig.new
      @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'content.primaryGenre.metadata.slug',"in").to_s+"&fresh=true"
      @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

    after(:all) do

    end

    it_behaves_like "v3 object general get search common checks", 60

    it "should return only releases with a content.primaryGenre.metadata.slug value that includes the following: #{in_val}" do
      @data['data'].each do |release|
        in_val.split(",").include?(release['content']['primaryGenre']['metadata']['slug']).should be_true
      end
    end

    in_val.split(",").each do |val|
      it "should return at least one release with a content.primaryGenre.metadata.slug value of #{val}" do
        platform_data = []
        @data['data'].each do |release|
          platform_data << release['content']['primaryGenre']['metadata']['slug']
        end
        platform_data.include?(val).should be_true
      end
    end

  end
end

################################################################

["3ds,nds","xbox-360,pc,ps3","ps,ps2"].each do |in_val|
  describe "V3 Object API -- GET Search - Search Using Condition 'in' using: #{GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'hardware.platform.metadata.slug','notIn')}" do

    before(:all) do
      PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
      @config = PathConfig.new
      @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.search_using_condition_in(in_val,'hardware.platform.metadata.slug',"notIn").to_s+"&fresh=true"
      @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

    after(:all) do

    end

    it_behaves_like "v3 object general get search common checks", 60

    in_val.split(",").each do   |slug|
      it "should not return any releases with a hardware.platform.metadata.slug value of #{slug}" do
        @data['data'].each do |release|
          release['hardware']['platform']['metadata']['slug'].should_not == slug
        end
      end
    end

  end
end

################################################################

%w(theater on-demand made-for-tv direct-to-video).each do |movie_type|
describe "V3 Object API -- GET Search - Search Movies By Type using: #{GeneralGetSearchHelperMethods.search_movies_by_type(movie_type)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.search_movies_by_type(movie_type).to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 55

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should return only releases with a metadata.movie.metadata.type with a value of '#{movie_type}'" do
    @data['data'].each do |movie|
      movie['metadata']['movie']['metadata']['type'].should == movie_type
    end
  end

end
end

################################################################

{1=>GeneralGetSearchHelperMethods.search_movie_by_legacy_id(Me3GameId.dark_knight_legacy_id),2=>GeneralGetSearchHelperMethods.search_movie_by_legacy_id_embedded(Me3GameId.dark_knight_legacy_id)}.each do |k,call|
describe "V3 Object API -- GET Search - Search Movies By legacyId using: #{call}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+call.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it "should return #{k} releases" do
    if  k == 1
      @data['data'].length.should == 1
    else
      @data['data'].length.should == 3
    end
  end

  it "should return a release with a metadata.name value of 'The Dark Knight Rises'" do
    @data['data'][0]['metadata']['name'].should == "The Dark Knight Rises"
  end
end
end

################################################################

%w(action comedy drama thriller).each do |genre|
[GeneralGetSearchHelperMethods.search_movie_by_genre(genre)].each do |call|
describe "V3 Object API -- GET Search - Search Movies By Genre using: #{call}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+call.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should return only movies with a content.primaryGenre.metadata.slug value of '#{genre}'" do
    @data['data'].each do |movie|
      movie['metadata']['movie'].has_key?('movieId').should be_true
      movie['content']['primaryGenre']['metadata']['slug'].should == genre
    end
  end
end
end
end

################################################################

describe "V3 Object API -- GET Search - Search Books using: #{GeneralGetSearchHelperMethods.search_books}" do
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q="+GeneralGetSearchHelperMethods.search_books.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 200

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should return 200 entries" do
    @data['data'].length.should == 200
  end

  it "should return a metadata.book.bookId value that is a 24-character hash for all releases" do
    @data['data'].each do |book|
      book['metadata']['book']['bookId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

end

################################################################
[GeneralGetSearchHelperMethods.search_books_by_legacy_id, GeneralGetSearchHelperMethods.search_books_by_slug].each do |call|

 describe "V3 Object API -- GET Search - Search Books using: #{call}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{call}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it "should return one release" do
    @data['data'].length.should == 1
  end

  it "should return a book with a metadata.slug value of 'batman-the-dark-knight-2011-11'" do
    @data['data'][0]['metadata']['book']['metadata']['slug'].should == 'batman-the-dark-knight-2011-11'
  end

  it "should return a book with a metadata.legacyId value of '138260'" do
    @data['data'][0]['metadata']['book']['metadata']['legacyId'].should == 138260
  end

end
end

################################################################

describe "V3 Object API -- GET Search - Search Volumes using: #{GeneralGetSearchHelperMethods.search_books_by_volume}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{GeneralGetSearchHelperMethods.search_books_by_volume}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should return at least one release" do
    @data['data'].length.should > 0
  end

  it "should return a volume with a metadata.book.metadata.volume.metadata.slug value of 'batman-the-dark-knight-2011' for all releases" do
    @data['data'].each do  |vol|
      vol['metadata']['book']['metadata']['volume']['metadata']['slug'].should == 'batman-the-dark-knight-2011'
    end
  end

  it "should return a volume with a metadata.book.metadata.volume.metadata.legacyId value of '110600' for all releases" do
    @data['data'].each do  |vol|
      vol['metadata']['book']['metadata']['volume']['metadata']['legacyId'].should == 110600
    end
  end

end

################################################################

describe "V3 Object API -- GET Search - Search Volumes using: #{GeneralGetSearchHelperMethods.search_volumes}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{GeneralGetSearchHelperMethods.search_volumes}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 200

  it_behaves_like "v3 object general get search check Id", 'releaseId'

  it "should return 200 releases" do
    @data['data'].length.should == 200
  end

  it "should return metadata.book.metadata.volume.volumeId value that is a 24-character hash for all releases" do
    @data['data'].each do |vol|
      vol['metadata']['book']['metadata']['volume']['volumeId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end

end

# End /release search and begin /roles search

################################################################

describe "V3 Object API -- GET Search - Search Roles RoleType using: #{GeneralGetSearchHelperMethods.search_role_roletype}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/roles/search?q=#{GeneralGetSearchHelperMethods.search_role_roletype}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 200

  it_behaves_like "v3 object general get search check Id", 'roleId'

  it "should return 200 releases" do
    @data['data'].length.should == 200
  end

  it "should return a metadata.roleType.metadata.slug value of 'director' for all roles" do
    @data['data'].each do |role|
      role['metadata']['roleType']['metadata']['slug'].should == 'director'
    end
  end

end

################################################################

describe "V3 Object API -- GET Search - Search Roles Person using: #{GeneralGetSearchHelperMethods.search_role_person}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/roles/search?q=#{GeneralGetSearchHelperMethods.search_role_person}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search check Id", 'roleId'

  it "should return at least one releases" do
    @data['data'].length.should > 0
  end

  it "should return a metadata.person.metadata.legacyId value of '913626' for all roles" do
    @data['data'].each do |role|
      role['metadata']['person']['metadata']['legacyId'].should == 913626
    end
  end

  it "should return a metadata.person.metadata.slug value of 'charles-roven' for all roles" do
    @data['data'].each do |role|
      role['metadata']['person']['metadata']['slug'].should == 'charles-roven'
    end
  end

end

################################################################

describe "V3 Object API -- GET Search - Search Roles Movie using: #{GeneralGetSearchHelperMethods.search_role_movie_exists}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/roles/search?q=#{GeneralGetSearchHelperMethods.search_role_movie_exists}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search common checks", 200

  it_behaves_like "v3 object general get search check Id", 'roleId'

  it "should return at least one releases" do
    @data['data'].length.should > 0
  end

  it "should return a metadata.movie.movieId value of that is a 24 character hash for all roles" do
    @data['data'].each do |role|
      role['metadata']['movie']['movieId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end

  it "should return metadata.movie.metadata.slug data with a non-nil, non-blank value for all roles" do
    @data['data'].each do |role|
      role['metadata']['movie']['metadata']['slug'].should_not be_nil
      role['metadata']['movie']['metadata']['slug'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

end

################################################################

describe "V3 Object API -- GET Search - Search Roles Characters using: #{GeneralGetSearchHelperMethods.search_role_character}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/roles/search?q=#{GeneralGetSearchHelperMethods.search_role_character}&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

  after(:all) do

  end

  it_behaves_like "v3 object general get search check Id", 'roleId'

  it "should return at least 60 releases" do
    @data['data'].length.should > 59
  end

  it "should return a metadata.character.metadata.slug value of 'batman' for all roles" do
    @data['data'].each do |role|
      role['metadata']['character']['metadata']['slug'].should == 'batman'
    end
  end

  it "should return a metadata.character.metadata.legacyId value of '924128' for all roles" do
    @data['data'].each do |role|
      role['metadata']['character']['metadata']['legacyId'].should == 924128
    end
  end

end

################################################################

%w(0 200 400 600).each do |index|
%w(releases roles).each do |obj|
describe "V3 Object API -- GET Search - Search #{obj} Using: #{GeneralGetSearchHelperMethods.search_without_state_filter(index)}" do

before(:all) do
  PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
  @config = PathConfig.new
  @url = "http://#{@config.options['baseurl']}/#{obj}/search?q=#{GeneralGetSearchHelperMethods.search_without_state_filter(index)}&fresh=true"
  @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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

after(:all) do

end


  it "should return 200 releases" do
    @data['data'].length.should == 200
  end

  it "should return only published releases" do
    @data['data'].each do |o|
      o['metadata']['state'].should == 'published'
    end
  end

end end end

################################################################

describe "V3 Object API -- GET Search - Search Releases Using: #{GeneralGetSearchHelperMethods.release_by_popularity}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{GeneralGetSearchHelperMethods.release_by_popularity}&fresh=truetest/spec/v3/object"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return releases by desc metadata.popularity" do
    @data['data'].count.should == 100
    popularity = []
    @data['data'].each do |release|
      popularity << release['metadata']['popularity']
    end
    popularity.length.should > 0
    popularity.sort {|x,y| y <=> x }.should == popularity
  end


end
