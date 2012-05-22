require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'
require 'time'

include Assert

def published_articles
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

def blogs
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

def cheats
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

def skyrim_cheats
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

def wii
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

def tech
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

def common_assertions
  
  it "should return a hash with five indices" do
    check_indices(@data, 6)
  end

  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'count' data with a value of 20" do
    @data['count'].should == 10
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
    @data['endIndex'].should == 9
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

  it "should return 'total' data with a value greater than 20" do
    @data['total'].should > 20
  end

  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'data' with an array length of 20" do
    @data['data'].length.should == 10
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
  
end

########################## BEGIN SPEC ########################## 

describe "V3 Articles API -- General Post Search for published articles sending #{published_articles}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search"
    begin 
       @response = RestClient.post @url, published_articles, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
    end
    @data = JSON.parse(@response.body)
    
    
    File.open('/Users/wclaiborne/Desktop/article_debug.json', 'w') {|f| f.write(@response.to_s) }
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  common_assertions

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
=begin
  it "should return the first article with a publish date no more than an hour old" do
     time_now = Time.new
     time_last_published = Time.parse(@data['data'][0]['metadata']['publishDate'])
     (time_now - time_last_published).should < 3601
  end
=end  
end

###############################################################

{'wii'=>wii,'tech'=>tech}.each_pair do |hub, search|
describe "V3 Articles API -- General Post Search for #{hub} hub using #{search}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search"
    begin 
       @response = RestClient.post @url, search, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  common_assertions

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

describe "V3 Articles API -- General Post Search for Blogs sending #{blogs}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search"
    begin 
       @response = RestClient.post @url, blogs, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end

  common_assertions
  
  it "should retrun 'articleType' metadata with a value of 'post' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'post'
    end
  end
  
  it "should return the first blog with a publish date no more than an hour old" do
     time_now = Time.new
     time_last_published = Time.parse(@data['data'][0]['metadata']['publishDate'])
     (time_now - time_last_published).should < 3601
  end
  
end

###############################################################

describe "V3 Articles API -- General Post Search for Cheats sending #{cheats}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search"
    begin 
       @response = RestClient.post @url, cheats, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  common_assertions
  
  it "should retrun 'articleType' metadata with a value of 'cheat' for all articles" do
    @data['data'].each do |article|
      article['metadata']['articleType'].should == 'cheat'
    end
  end
  
end

###############################################################

describe "V3 Articles API -- General Post Search for Skyrim Cheats sending #{skyrim_cheats}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search"
    begin 
       @response = RestClient.post @url, skyrim_cheats, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url+" "+e.response)
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
  
  it "should retrun 'articleType' metadata with a value of 'cheat' for all articles" do
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

