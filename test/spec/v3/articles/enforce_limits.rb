require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

# Enfore count limit on GET ?count query
# Enfore count limit on GET search 
# Enfore count limit on GET search with startIndex
# Enfore list limit on GET ?metadata.slug query
# Enfore list limit for contains* values on GET search

# Enfore count on GET ?count query
%w(201 300).each do |count|
['', '&startIndex=20'].each do |start_index|
describe "V3 Articles API -- Count Limit on GET -- v3/articles?count=#{count}#{start_index} (max = 200)", :smoke => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles?count=#{count}#{start_index}&fresh=true"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should only return 200 articles" do
    @data['data'].count.should == 200
  end
  
  it "should return count with a value of 200" do
    @data['count'].should == 200
  end
  
  it "should return the appropriate startIndex value" do
    if start_index.empty?
      @data['startIndex'].should == 0
    else
      @data['startIndex'].should == start_index.match(/\d\d/).to_s.to_i
    end
  end
  
  it "should return the appropriate endIndex value" do
    if start_index.empty?
      @data['endIndex'].should == 199
    else
      @data['endIndex'].should == start_index.match(/\d\d/).to_s.to_i+199
    end
    
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].to_s.should == 'true'
  end
  
end end end

# Enfore count on GET search
describe "V3 Articles API -- Count Limit On GET Search Endpoint count = 201", :smoke => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+{"count"=>201,"fields"=>["metadata.articleType","metadata.headline","metadata.publishDate"]}.to_json.to_s+"&fresh=true"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin 
       @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end
  
  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  
  it "should only return 200 articles" do
    @data['data'].count.should == 200
  end
  
  it "should return count with a value of 200" do
    @data['count'].should == 200
  end
  
  it "should return the appropriate startIndex value" do
    @data['startIndex'].should == 0
  end
  
  it "should return the appropriate endIndex value" do
    @data['endIndex'].should == 199
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].to_s.should == 'true'
  end
  
end

# Enfore count on GET search with startIndex
describe "V3 Articles API -- Count Limit On GET Search  (count = 300 & startIndex = 20)", :smoke => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+{"count"=>300,"startIndex"=>20,"fields"=>["metadata.articleType","metadata.headline","metadata.publishDate"]}.to_json.to_s+"&fresh=true" 
    puts @url
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin 
       @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end
  
  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should only return 200 articles" do
    @data['data'].count.should == 200
  end
  
  it "should return count with a value of 200" do
    @data['count'].should == 200
  end
  
  it "should return the appropriate startIndex value" do
    @data['startIndex'].should == 20
  end
  
  it "should return the appropriate endIndex value" do
    @data['endIndex'].should == 20+199
  end
  
  it "should return isMore with a value of true" do
    @data['isMore'].to_s.should == 'true'
  end
  
end

# Enfore list limit on GET ?metadata.slug query
%w(zz1,zz2,zz3,zz4,zz5,zz6,zz7,zz7,zz9,zz10,zz11,zz12,zz13,zz14,zz15,zz16,zz17,zz18,zz19,sweet-new-avengers-posters,apple-ipad-review-2012).each do |slugs|
describe "V3 Articles API -- Slug List Limit on GET", :smoke => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/slugs/#{slugs}&fresh=true"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return the sweet-new-avengers-posters article" do
    articles = []
    @data['data'].each do |article|
      articles << article['metadata']['slug']
    end
    articles.include?('sweet-new-avengers-posters').should be_true
  end
  
  it "should not reutrn the apple-ipad-review-2012 article" do
    articles = []
    @data['data'].each do |article|
      articles << article['metadata']['slug']
    end
    articles.include?('sapple-ipad-review-2012').should be_false
  end
   
end end

# Enfore list limit for contains* values on GET search
%w(contains containsOne).each do |contains|
describe "V3 Articles API -- Contains Limit On GET Search ", :smoke => true, :test => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/v3/articles/search?q="+ArticleAPIHelper.enforce_max_contains(contains)+"&fresh=true"
    puts @url
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin 
       @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end
  
  it "should return 200" do
    check_200(@response)
  end
  
  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "should return a hash with five indices" do
    check_indices(@data, 6)
  end
  
  it "should return at least one article" do
    @data['data'].count.should > 0
  end
  
  it "should only return articles tagged ps3" do
    @data['data'].each do |article|
      article_tags = []
      article['tags'].each do |tag|
        article_tags << tag['slug']
      end
      article_tags.include?('ps3').should be_true
    end
  end
  
  it "should not return any articles tagged xbox-360" do
    @data['data'].each do |article|
      article_tags = []
      article['tags'].each do |tag|
        article_tags << tag['slug']
      end
      article_tags.include?('xbox-360').should be_false
    end
  end
  
end end
  