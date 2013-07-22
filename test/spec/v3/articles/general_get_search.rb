require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'time'
require 'article_api_helper'

include Assert

class ArticleGetSearchHelper
  
  @article_id = ""

  def self.return_article_id
    @article_id 
  end
  
  def self.set_article_id(id)
    @article_id = id
  end

  def self.published_articles
  {"matchRule"=>"matchAll",
   "count"=>10,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
     {"field"=>"metadata.articleType",
       "condition"=>"is",
       "value"=>"article"}
       ],
   "sortBy"=>"metadata.publishDate",
   "sortOrder"=>"desc"
  }.to_json
  end

  def self.blogs
  {"matchRule"=>"matchAll",
   "sortBy"=>"metadata.publishDate",
   "sortOrder"=>"desc",
   "count"=>10,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
     {"field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"post"},
     {"field"=>"system.spam",
      "condition"=>"isNot",
      "value"=>1}
     ]
  }.to_json
  end

  def self.cheats
  {"matchRule"=>"matchAll",
   "sortBy"=>"metadata.publishDate",
   "sortOrder"=>"desc",
   "count"=>10,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
     {"field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"cheat"},
     ]
  }.to_json
  end

  def self.skyrim_cheats
  {"matchRule"=>"matchAll",
   "count"=>100,
   "rules"=>[
     {"field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"cheat"},
     {"field"=>"legacyData.objectRelations",
       "condition"=>"is",
       "value"=>"14267318"}
    ]
  }.to_json
  end

  def self.wii
  {"matchRule"=>"matchAll",
   "count"=>10,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
     {"field"=>"metadata.articleType",
       "condition"=>"is",
       "value"=>"article"},
     {"field"=>"categories.slug",
      "condition"=>"contains",
      "value"=>"wii"},
     {"field"=>"categoryLocales",
      "condition"=>"contains",
      "value"=>"us"}
      ],
    "sortBy"=>"metadata.publishDate",
    "sortOrder"=>"desc"
  }.to_json
  end

  def self.tech
  {"matchRule"=>"matchAll",
   "count"=>10,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
     {"field"=>"metadata.articleType",
       "condition"=>"is",
       "value"=>"article"},
     {"field"=>"categories.slug",
       "condition"=>"contains",
       "value"=>"tech"},
     {"field"=>"categoryLocales",
       "condition"=>"contains",
       "value"=>"us"}
       ],
   "sortBy"=>"metadata.publishDate",
   "sortOrder"=>"desc"
  }.to_json
  end

  def self.blogroll(category)
  {
    "matchRule"=>"matchAll",
    "count"=>100,
    "startIndex"=>0,
    "networks"=>"ign",
    "states"=>"published",
    "rules"=>[
    {
      "field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"article"
    },
    {
      "field"=>"categories.slug",
      "condition"=>"contains",
      "value"=>category
    },
    {
      "field"=>"categoryLocales",
      "condition"=>"contains",
      "value"=>"us"
    }
    ],
    "sortBy"=>"metadata.publishDate",
    "sortOrder"=>"desc"
  }.to_json
  end

  def self.object_relation_is(id)
  {
    "matchRule"=>"matchAll",
    "sortBy"=>"metadata.publishDate",
    "sortOrder"=>"desc",
    "count"=>200,
    "startIndex"=>0,
    "networks"=>"ign",
    "states"=>"published",
    "rules"=>[
    {
      "field"=>"legacyData.objectRelations",
      "condition"=>"is",
      "value"=>id
    },
    {
      "field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"article"
    }
    ]
  }.to_json
  end

  def self.object_relation_contains(id, verb)
  {
    "matchRule"=>"matchAll",
    "sortBy"=>"metadata.publishDate",
    "sortOrder"=>"desc",
    "count"=>200,
    "startIndex"=>0,
    "networks"=>"ign",
    "states"=>"published",
    "rules"=>[
    {
      "field"=>"legacyData.objectRelations",
      "condition"=>verb, # pass in contains and containsOne
      "value"=>id
    },
    {
      "field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"article"
    }
    ]
  }.to_json
  end

  def self.contains(verb)
  {
    "matchRule"=>"matchAll",
    "sortBy"=>"metadata.publishDate",
    "sortOrder"=>"desc",
    "count"=>200,
    "startIndex"=>0,
    "networks"=>"ign",
    "states"=>"published",
    "rules"=>[
    {
      "field"=>"tags",
      "condition"=>verb, #pass containsAll and containsNone
      "value"=>"ps3, xbox-360"
    },
    {
      "field"=>"metadata.articleType",
      "condition"=>"is",
      "value"=>"article"
    }
    ]
  }.to_json
  end

  def self.is_not(type)
  {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
      "field"=>"metadata.articleType",
      "condition"=>"isNot",
      "value"=>type
      }
    ],
    "startIndex"=>0,
    "count"=>200,
    "networks"=>"ign",
    "states"=>"published"
  }.to_json
  end

  def self.date_range
  {
    "matchRule"=>"matchAll",
    "rules"=>[],
    "startIndex"=>0,
    "count"=>200,
    "networks"=>"ign",
    "states"=>"published",
    "fromDate"=>"2012-01-01T00:00:00-0000",
    "toDate"=>"2012-12-31T00:00:00-0000"
  }.to_json
  end

  def self.nested_query
  {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
      "field"=>"tags",
      "rules"=>[
        {
        "field"=>"tags.slug",
        "condition"=>"is",
        "value"=>"ps3"
        },
        {
        "field"=>"tags.tagType",
        "condition"=>"is",
        "value"=>"platform"
        }
      ]
      }
    ],
    "networks"=>"ign",
    "states"=>"published",
    "startIndex"=>0,
    "count"=>200,
  }.to_json
  end
  
  def self.tag_contains
    {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
         "field"=>"tags.slug",
         "condition"=>"containsAll",
         "value"=>"ps3,action"
      },
      {
         "field"=>"tags.slug",
         "condition"=>"containsNone",
         "value"=>"movies,pc,xbox-360,news"
      }
    ],
    "startIndex"=>0,
    "count"=>200
    }.to_json
  end
  
  def self.category_contains(n)
    {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
         "field"=>"categories.slug",
         "condition"=>"containsAll",
         "value"=>"ps3,ign"
      },
      {
         "field"=>"categories.slug",
         "condition"=>"containsNone",
         "value"=>"xbox-360,pc"
      }
    ],
    "startIndex"=>n.to_i,
    "count"=>200
    }.to_json
  end
  
  def self.category_contains_one(n)
    {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
         "field"=>"categories.slug",
         "condition"=>"containsOne",
         "value"=>"pc"
      }
    ],
    "startIndex"=>n.to_i,
    "count"=>200
    }.to_json
  end

end

########################## BEGIN SPEC ########################## 

describe "V3 Articles API -- General Get Search for published articles sending #{ArticleGetSearchHelper.published_articles}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.published_articles.to_s+"&fresh=true"
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
  
  include_examples "basic article API checks", 10

  # metadata assertions

  ["headline",
    "state",
    "slug",
    "publishDate",
    "articleType",].each do |k|
      
    it "should return '#{k}' metadata for all articles" do
      @data['data'].each do |article|
        article['metadata'].has_key?(k).should be_true
      end
    end
    
    if k == "headline"
    
      it "should return non-nil, non-blank '#{k}' metadata for all articles", :prd => true do
        @data['data'].each do |article|
        article['metadata'][k].should_not be_nil
        article['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
        end
      end
    
    else
      
      it "should return non-nil, non-blank '#{k}' metadata for all articles" do
        @data['data'].each do |article|
        article['metadata'][k].should_not be_nil
        article['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
        end
      end
      
    end# end if/else
  end# end iteration
  
  it "should return 'articleType' metadata with a value of 'article' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'article'
    end
  end

  it "should return the first article with a publish date no more than 6 days old", :prd => true  do
     time_now = Time.new
     time_last_published = Time.parse(@data['data'][0]['metadata']['publishDate'])
     (time_now - time_last_published).should < 3600*24*6
  end

end

###############################################################

{'wii'=>ArticleGetSearchHelper.wii,'tech'=>ArticleGetSearchHelper.tech}.each_pair do |hub, search|
describe "V3 Articles API -- General Get Search for #{hub} hub using #{search}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+search.to_s+"&fresh=true"
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
  
  include_examples "basic article API checks", 10

  # metadata assertions

  ["headline",
    "state",
    "slug",
    "publishDate",
    "articleType",].each do |k|
    it "should return '#{k}' metadata for all articles" do
      @data['data'].each do |article|
        article['metadata'].has_key?(k).should be_true
      end
    end
    
    it "should return non-nil, non-blank '#{k}' metadata for all articles" do
      @data['data'].each do |article|
      article['metadata'][k].should_not be_nil
      article['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end# end iteration
  
  it "should retrun 'articleType' metadata with a value of 'article' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'article'
    end
  end

  it "should return 'categories' data with a slug value that includes '#{hub}' for all articles" do
    @data['data'].each do |article|
      category_includes_url_slug = false
      article['categories'].each do |cat|
        if cat.to_s.match(/"slug"=>"#{hub}"/)
          category_includes_url_slug = true
        end#end if
      end#end cat
      category_includes_url_slug.should be_true
    end#end article
  end

  it "should return 'categoryLocales' data with a value that includes 'us' for all articles" do
    @data['data'].each do |article|
      article['categoryLocales'].include?('us').should be_true
    end
  end

  # legacyData assertions

  # tags assertions

  # refs assertions

  # authors assertions

  # categoryLocales assertions

  # promo assertions

  # categories assertions

  # content assertions
  
end
end

###############################################################

describe "V3 Articles API -- General Get Search for Blogs sending #{ArticleGetSearchHelper.blogs}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.blogs.to_s+"&fresh=true"
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

  include_examples "basic article API checks", 10
  
  it "should retrun 'articleType' metadata with a value of 'post' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'post'
    end
  end
  
  it "should return the first blog with a publish date no more than an hour old", :prd => true do
     time_now = Time.new
     time_last_published = Time.parse(@data['data'][0]['metadata']['publishDate'])
     (time_now - time_last_published).should < 3601
  end
  
end

###############################################################

describe "V3 Articles API -- General Get Search for Cheats sending #{ArticleGetSearchHelper.cheats}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.cheats.to_s+"&fresh=true"
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
  
  include_examples "basic article API checks", 10
  
  it "should return 'articleType' metadata with a value of 'cheat' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'cheat'
    end
  end
  
end

###############################################################

describe "V3 Articles API -- General Get Search for Skyrim Cheats sending #{ArticleGetSearchHelper.skyrim_cheats}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.skyrim_cheats.to_s+"&fresh=true"
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

  it "should return a hash with five indices" do
    check_indices(@data, 6)
  end

  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'count' data with a value of 20" do
    @data['count'].should > 46
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

  it "should return 'endIndex' data with a value of 19" do
    @data['endIndex'].should > 45
  end

  it "should return 'isMore' data with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'total' data with a non-nil, non-blank value" do
    @data.has_key?('total').should be_true
    @data['total'].should_not be_nil
    @data['total'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'total' data with a value greater than 20" do
    @data['total'].should > 20
  end

  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'data' with an array length of 20" do
    @data['data'].length.should > 46
  end

  it "should return 'networks' metadata with a value that includes 'ign' for all articles" do
    @data['data'].each do |article|
      article['metadata']['networks'].include?('ign').should be_true
    end
  end

  it "should return 'state' metadata with a value of 'published' for all articles" do
    @data['data'].each do |article|
      article['metadata']['state'].should == 'published'
    end
  end

  it "should return articles in descending 'publishDate' order" do
    pub_date_array = []
    @data['data'].each do |article|
      article['metadata']['publishDate'].should_not be_nil
      pub_date_array << Time.parse(article['metadata']['publishDate'])
    end
    pub_date_array.should == (pub_date_array.sort {|x,y| y <=> x })
  end

  it "should return non-nil, non-blank 'articleId' data for all articles" do
    @data['data'].each do |article|
      article['articleId'].should_not be_nil
      article['articleId'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return an articleId with a 24-character hash value for all articles" do
    @data['data'].each do |article|
      article['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end

  [ "articleId",
    "metadata",
    "system",
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "categories",
    "content"].each do |k|
    it "should return non-nil '#{k}' data for all articles" do
      @data['data'].each do |article|
        article.has_key?(k).should be_true
        article.should_not be_nil
        article.to_s.length.should > 0
      end
    end
  end#end iteration
  
  it "should return 'articleType' metadata with a value of 'cheat' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'cheat'
    end
  end
  
  it "should return 'legacyData.objectRelations' data that includes the integer 14267318 for all articles" do
    @data['data'].each do |article|
      article['legacyData']['objectRelations'].include?(14267318).should be_true
    end
  end
  
end

###############################################################

%w(xbox-360 ps3 wii ps-vita pc ds wireless movies tv comics).each do |category|
describe "V3 Articles API -- General Get Search for the #{category} blogroll using #{ArticleGetSearchHelper.blogroll(category)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.blogroll(category).to_s+"&fresh=true"
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

  include_examples "basic article API checks", 100

  it "should return only articles categorized as '#{category}'" do
    @data['data'].each do |article|
      category_slug = []
      article['categories'].each do |cat|
        category_slug << cat['slug']
      end
      category_slug.should include category
    end
  end

  it "should return the 10th article with a publish date no more than 6 days old", :prd => true do
    time_now = Time.new
    time_last_published = Time.parse(@data['data'][9]['metadata']['publishDate'])
    (time_now - time_last_published).should < 3600*24*6
  end

end end

###############################################################

%w(contains containsAll).each do |rule|
[110563].each do |id|
describe "V3 Articles API -- General Get Search Halo 4 articles using #{ArticleGetSearchHelper.object_relation_is(id)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.object_relation_is(id).to_s+"&fresh=true"
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

  it 'should return at least two articles' do
    @data['data'].count.should > 1
  end

  it 'should return over 135 articles', :prd => true do
    @data['data'].count.should > 135
  end

  it 'should return only articles with Halo 4 attached' do
    @data['data'].each do |article|
      article['legacyData']['objectRelations'].should include id
    end
  end

  it "should return the same articles when when asking for 'contains' Halo 4" do
    url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.object_relation_contains(id,rule).to_s
    url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin
      response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    is_articles,contains_articles = [], []

    @data['data'].each do |article|
      is_articles << article['articleId']
    end

    data['data'].each do |article|
      contains_articles << article['articleId']
    end

    is_articles.should == contains_articles

  end

end end end

###############################################################

describe "V3 Articles API -- General Get Search with 'containsAll' using #{ArticleGetSearchHelper.contains('containsAll')}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.contains('containsAll').to_s+"&fresh=true"
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

  context 'Basic Checks', :prd => true do
    include_examples "basic article API checks", 200
  end

  it 'should return at least 10 articles', :stg => true do
    @data['data'].count.should > 9
  end

  it "should return only articles tagged both 'ps3' and 'xbox-360'" do
    @data['data'].each do |article|
      tags = []
      article['tags'].each do |tag|
        tags << tag['slug']
      end
      tags.should include 'ps3'
      tags.should include 'xbox-360'
    end
  end

end

###############################################################

describe "V3 Articles API -- General Get Search with 'containsNone' using #{ArticleGetSearchHelper.contains('containsNone')}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.contains('containsNone').to_s+"&fresh=true"
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

  context 'Basic Checks' do
    include_examples "basic article API checks", 200
  end

  it "should return only articles tagged neither 'ps3' nor 'xbox-360'" do
    total_tags = []
    @data['data'].each do |article|
      tags = []
      article['tags'].each do |tag|
        tags << tag['slug']
        total_tags << tag['slug']
      end
      tags.should_not include('ps3'||'xbox-360')
    end
    total_tags.length.should > 250
  end

end

###############################################################

describe "V3 Articles API -- General Get Search with 'isNot' using #{ArticleGetSearchHelper.is_not('article')}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.is_not('article').to_s+"&fresh=true"
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

  context 'Basic Checks', :prd => true do
    include_examples "basic article API checks", 200
  end

  it 'should implement basic checks for stage'

  it "should not return articles with an articleType of 'article'" do
    article_types = []
    @data['data'].each do |article|
      article_types << article['metadata']['articleType']
    end
    article_types.length.should > 100
    article_types.should_not include 'article'
  end

end

###############################################################

describe "V3 Articles API -- General Get Search with 'isNot' using #{ArticleGetSearchHelper.date_range}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.date_range.to_s+"&fresh=true"
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

  context 'Basic Checks', :prd => true do
    include_examples "basic article API checks", 200
  end

  it 'should implement basic checks for stage'

  it 'should only return articles from 2012' do
    @data['data'].each do |article|
      article['metadata']['publishDate'].match(/2012-/).should be_true
    end
  end

end

###############################################################

describe "V3 Articles API -- General Get Search with a nested query using #{ArticleGetSearchHelper.nested_query}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.nested_query.to_s+"&fresh=true"
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

  context 'Basic Checks' do
    include_examples "basic article API checks", 200
  end

  it "should only return articles tagged 'ps3 with a tagType of 'platform'" do
    @data['data'].each do |article|
      correct_tags = false
      article['tags'].each do |tag|
        correct_tags = true if tag.to_s.match(/ps3/) && tag.to_s.match(/platform/)
      end
      correct_tags.should be_true
    end
  end

end

###############################################################

describe "V3 Articles API -- General Get Search with 'containsNone' and 'containsAll' using #{ArticleGetSearchHelper.tag_contains}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.tag_contains.to_s+"&fresh=true"
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

  context 'Basic Checks' do
    include_examples "basic article API checks", 200
  end

  it "should only return articles tagged with 'ps3' and 'feature'" do
    @data['data'].each do |article|
      tags = []
      article['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('ps3').should be_true
      tags.include?('action').should be_true
    end  
  end
  
  it "should not return any articles with the following tags, 'movies, pc, xbox-360, news'" do
    @data['data'].each do |article|
      tags = []
      article['tags'].each do |t|
        tags << t['slug']
      end
      tags.include?('movies').should be_false
      tags.include?('pc').should be_false
      tags.include?('xbox-360').should be_false
      tags.include?('news').should be_false
    end
  end
  
end

###############################################################

%w(0 200 400).each do |num|
describe "V3 Articles API -- General Get Search with 'containsNone' and 'containsAll' using #{ArticleGetSearchHelper.category_contains(num)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.category_contains(num).to_s+"&fresh=true"
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

  context 'Basic Checks' do
    include_examples "basic article API checks", 200
  end

  it "should only return articles with categories of 'ps3' and 'ign'" do
    @data['data'].each do |article|
      categories = []
      article['categories'].each do |c|
        categories << c['slug']
      end
      categories.include?('ps3').should be_true
      categories.include?('ign').should be_true
    end  
  end
  
  it "should not return any articles with categories of 'xbox-360' or 'pc'" do
    @data['data'].each do |article|
      categories = []
      article['categories'].each do |c|
        categories << c['slug']
      end
      categories.include?('xbox-360').should be_false
      categories.include?('pc').should be_false
    end
  end

end 
end

###############################################################

%w(0 200).each do |num|
describe "V3 Articles API -- General Get Search with 'containsNone' and 'containsAll' using #{ArticleGetSearchHelper.category_contains_one(num)}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleGetSearchHelper.category_contains_one(num).to_s+"&fresh=true"
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

  context 'Basic Checks' do
    include_examples "basic article API checks", 200
  end

  it "should only return articles with a category of 'pc'" do
    @data['data'].each do |article|
      categories = []
      article['categories'].each do |c|
        categories << c['slug']
      end
      categories.include?('pc').should be_true
    end  
  end

end 
end

