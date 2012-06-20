require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

[ "",
  "?metadata.state=published",
  "/type/post",
  "/type/cheat",
  "/type/article",
  "/state/published"].each do |call|

describe "V3 Articles API -- General Smoke Tests -- v3/articles#{call}", :smoke => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles#{call}"
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
  
  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'count' data with a value of 20" do
    @data['count'].should == 20
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
    @data['endIndex'].should == 19
  end
  
  it "should return 'isMore' data with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'isMore' data with a value of true" do
    @data['isMore'].should == true
  end

#  it "should return 'total' data with a non-nil, non-blank value" do
#    @data.has_key?('total').should be_true
#    @data['total'].should_not be_nil
#    @data['total'].to_s.delete("^a-zA-Z0-9").length.should > 0
#  end
  
#  it "should return 'total' data with a value greater than 20" #do
#    @data['total'].should > 20
#  end
  
  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  it "should return 'data' with an array length of 20" do
    @data['data'].length.should == 20
  end

  [ "articleId",
    "metadata", 
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
  
  # articleId assertions
  
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
  
  case call
  when "?metadata.state=published"
    it "should only return published articles" do
      @data['data'].each do |article|
        article['metadata']['state'].should == 'published'
      end
    end
  when "/type/post"
    it "should only return 'post' articleTypes" do
      @data['data'].each do |article|
        article['metadata']['articleType'].should == 'post'
      end
    end
  when "/type/cheat"
    it "should only return 'cheat' articleTypes" do
      @data['data'].each do |article|
        article['metadata']['articleType'].should == 'cheat'
      end
    end
  when "/type/article"
    it "should only return 'article' articleTypes" do
      @data['data'].each do |article|
        article['metadata']['articleType'].should == 'article'
      end
    end
  when "/state/published"
    it "should only return published articles" do
      @data['data'].each do |article|
        article['metadata']['state'].should == 'published'
      end
    end
  end#end switch statement

end
end

##################################################################

{"Slug"=>"/slug/calibur-11-crafts-battlefield-3-console-vaults", "ID"=>"/4e9caeb67ebbd8441c0000a0"}.each do |k,v|

describe "V3 Articles API -- Get Article By #{k} -- #{v}", :smoke => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/v3/articles#{v}"
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
  
  ["articleId",
    "metadata",
    "review", 
    "legacyData", 
    "metadata", 
    "system", 
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "promo",
    "categories",
    "content"].each do |k| 
    it "should return an article with #{k} data" do
      @data.has_key?(k).should be_true
    end   
  end
  
  ["articleId",
    "metadata",
    "system", 
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "promo",
    "categories",
    "content"].each do |k| 
    it "should return an article with non-nil, non-blank #{k} data" do
      @data[k].should_not be_nil
      @data[k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end   
  end
  
  # articleId assertions
  
  it "should return an article with an articleId value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
  end
  
  it "should return an article with an articleId value of 4e9caeb67ebbd8441c0000a0" do
    @data['articleId'].should == '4e9caeb67ebbd8441c0000a0'
  end
  
  # metadata assertions
  
  ["headline",
    "networks",
    "state",
    "slug",
    "subHeadline",
    "publishDate",
    "articleType",].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' metadata" do
      @data['metadata'].has_key?(k).should be_true
      @data['metadata'][k].should_not be_nil
      @data['metadata'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  it "should return an article with a slug value of 'calibur-11-crafts-battlefield-3-console-vaults'" do
    @data['metadata']['slug'].should == 'calibur-11-crafts-battlefield-3-console-vaults'
  end
  
  it "should return an article in the 'published' state" do
    @data['metadata']['state'].should == 'published'
  end
  
  it "should return an article with an articleType value of 'article'" do
    @data['metadata']['articleType'].should == 'article'
  end
  
  it "should return an article with a headline value of 'Calibur 11 Crafts Battlefield 3 Console Vaults'" do
    @data['metadata']['headline'].should == 'Calibur 11 Crafts Battlefield 3 Console Vaults'
  end
  
  it "should return an article with the subHeadline 'Calibur has the right equipment for your Xbox 360 or PS3.'" do
    @data['metadata']['subHeadline'].should == 'Calibur has the right equipment for your Xbox 360 or PS3.'
  end
  
  # review assertions  
  
  # legacyData assertions
  
#  ['legacyArticles','objectRelations'].each do |k|
#    it "should return an article with non-nil, non-blank '#{k}' data" #do
#      @data['legacyData'].has_key?(k).should be_true
#      @data['legacyData'][k].should_not be_nil
#      @data['legacyData'][k].to_s.length should > 0
#    end
#  end
  
  # system assertions
  
  ['createdAt','updatedAt'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data" do
      @data['system'].has_key?(k).should be_true
      @data['system'][k].should_not be_nil
      @data['system'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  # tags assertions
  
  it "should return an article with 15 non-nil, non-blank tags", :stg => true do
    @data['tags'].length.should == 15
    @data['tags'].each do |tag|
      tag.should_not be_nil
      tag.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  it "should return an article with 17 non-nil, non-blank tags", :prd => true do
    @data['tags'].length.should == 17
    @data['tags'].each do |tag|
      tag.should_not be_nil
      tag.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank '#{k}' data for each tag" do 
      @data['tags'].each do |tag|
        tag.has_key?(k).should be_true
        tag[k].should_not be_nil
        tag[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
  
  # refs assertions
  
  it "should return an article with a numberic wordpressId value" do
    @data['refs'].has_key?('wordpressId').should be_true
    @data['refs']['wordpressId'].should_not be_nil
    @data['refs']['wordpressId'].to_s.delete("^0-9").length.should > 0
  end
  
  it "should return an article with a wordpressId integer value of 59572" do
    @data['refs']['wordpressId'].should == 59572
  end
  
  it "should return an article with a numberic disqusId value" do
    @data['refs'].has_key?('disqusId').should be_true
    @data['refs']['disqusId'].should_not be_nil
    @data['refs']['disqusId'].to_s.delete("^0-9").length.should > 0
  end
  
  it "should return an article with a disqusId integer value of 1199416" do
    @data['refs']['disqusId'].should == 1199416
  end
  
  # authors assertions
  
  it "should return an article with a non-blank, non-nil author-name value" do
    @data['authors'][0].has_key?('name').should be_true
    @data['authors'][0]['name'].should_not be_nil
    @data['authors'][0]['name'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  # categoryLocales assertions
  
  it "should return an article with a categoryLocales value that includes the 'us' locale" do
    @data['categoryLocales'].to_s.match(/us/).should be_true
  end
  
  # promo assertions
  
  it "should return an article with promoImages data" do
    @data['promo'].has_key?('promoImages').should be_true
  end
  
  ['title','summary'].each do |k|
    it "should return an article with non-nil, non-blank #{k} data" do
      @data['promo'].has_key?(k).should be_true
      @data['promo'][k].should_not be_nil
      @data['promo'][k].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  # categories assertions
  
  it "should return an article with 4 non-nil, non-blank categories" do
    @data['categories'].length.should == 4
    @data['categories'].each do |categories|
      categories.should_not be_nil
      categories.to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  ['displayName','slug'].each do |k|
    it "should return an article with non-nil, non-blank #{k} data for each categories" do 
      @data['categories'].each do |categories|
        categories.has_key?(k).should be_true
        categories[k].should_not be_nil
        categories[k].to_s.delete("^a-zA-Z0-9").length.should > 0
      end
    end
  end
  
  # content assertions
  
  it "should return an article with content longer than 550 characters" do
    @data['content'].to_s.length.should > 550
  end

end
end