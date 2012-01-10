require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

### iterate for similar calls like state/published
### have a testsuite good for all calls (like state/discovered)

[ "", 
  "/state/published",
  "?metadata.state=published&metadata.networks=ign",
  "/network/ign?metadata.state=published",
  "/state/published?metadata.networks=ign&?metadata.state=published",
  "?sortOrder=asc&sortBy=metadata.name&?metadata.state=published",
  "?metadata.state=published&fields=metadata.name,metadata.networks,videoId"].each do |call|
##################################################################

##################################################################

describe "V3 Video API: Defaults" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}#{call}"
    puts @url
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
    check_200(@response, @data)
  end
  
  it "should not return blank" do
    check_not_blank(@response, @data)
  end
  
  it "should return a hash with six indices" do
    check_indices(@response, @data, 6)
  end
  
  it "shoud return a count key-value" do
    check_key(@response, @data, 'count')
  end
  
  it "should return count with a value of 20" do
    check_key_equals(@response, @data, 'count', 20)
  end
  
  it "shoud return a start key-value" do
    check_key(@response, @data, 'start')
  end
  
  it "should return start with a value of 0" do
    check_key_equals(@response, @data, 'start', 0)
  end
  
  it "shoud return an 'end' key-value" do
    check_key(@response, @data, 'end')
  end
  
  it "should return end with a value of 19" do
    check_key_equals(@response, @data, 'end', 19)
  end
  
  it "shoud return an isMore key-value" do
    check_key(@response, @data, 'isMore')
  end
  
  it "should return isMore with a value of true" do
    check_key_equals(@response, @data, 'isMore', true)
  end
  
  it "shoud return a total key-valye" do
    check_key(@response, @data, 'total')
  end
  
  it "should return total with a value greater than 20" do
    @data['total'].should > 20
  end
  
  it "shoud return a data key-valye" do
    check_key(@response, @data, 'data')
  end
  
  it "should return data with a length of 20" do
    @data['data'].length.should == 20
  end
  
  ["videoId",
    "assets",
    "thumbnails", 
    "objectRelations", 
    "metadata", 
    "tags", 
    "category"].each do |k| 
    it "should return videos with a #{k} key" do
      check_key_exists_for_all(@response, @data['data'], k)
    end
  end
  
  it "should not return any blank or nil videoId values" do
    check_key_value_exists_for_all(@response, @data['data'], "videoId")
  end
  
  it "should return videos with a hash videoId value" do
    @data['data'].each do |video|
      video['videoId'].match(/^[0-9a-f]{24,32}$/).should be_true  
    end  
  end
  
end
end

##################################################################

##################################################################

describe "V3 Video API: Get Video By Slug" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/slug/metal-gear-solid-hd-collection-video-review"
    puts @url
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
    check_200(@response, @data)
  end
  
  it "should not return blank" do
    check_not_blank(@response, @data)
  end
  
  it "should return a hash with 11 indices" do
    check_indices(@response, @data, 11)
  end
  
  ["videoId",
    "assets",
    "thumbnails", 
    "objectRelations", 
    "metadata", 
    "promo",
    "tags", 
    "extra",
    "refs",
    "category",
    "system"].each do |k| 
    it "should return a video with a #{k} key" do
      check_key(@response, @data, k)
    end
  end
  
  it "should return 7 assets" do
    @data['assets'].length.should == 7
  end
  
  it "should return a video with a videoId of 4eb87cb98e88c57b65000008" do
    @data['videoId'].should eql("4eb87cb98e88c57b65000008")
  end
  
  ["downloadable",
    "url",
    "bitrate",
    "height",
    "width",].each do |k| 
    it "should return a #{k} key for each asset" do
      check_key_exists_for_all(@response, @data['assets'], k)
    end
  end
  
  ["downloadable",
    "url",
    "bitrate",
    "height",
    "width",].each do |k| 
    it "should return a non-nil, non-blak value for the #{k} key for each asset" do
      check_key_value_exists_for_all(@response, @data['assets'], k)
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return a #{k} key for each thumbnail" do
      check_key_exists_for_all(@response, @data['thumbnails'], k)
    end
  end
  
  ["styleUrl",
    "url",
    "height",
    "width",].each do |k| 
    it "should return a non-nil, non-blank value for the #{k} key for each thumbnail" do
      check_key_value_exists_for_all(@response, @data['thumbnails'], k)
    end
  end
  
  ["commonName",
    "objectTypeId",
    "objectName",
    "contentRating",
    "legacyId",
    "platform",
    "objectType"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in objectRelations" do
      check_key(@response, @data['objectRelations'][0], k)
    end
  end

  ["name",
    "description",
    "publishDate",
    "title",
    "longTitle",
    "duration",
    "url",
    "locale",
    "slug",
    "ageGate",
    "classification",
    "subClassification",
    "networks",
    "state",
    "noads",
    "prime",
    "subscription",
    "downloadable",
    "creator",
    "origin"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in metadata" do
      check_key(@response, @data['metadata'], k)
    end
  end
  
  it "should return 14 slug keys for tags" do
    check_key_exists_for_all(@response, @data['tags'], 'slug')
    @data['tags'].length.should == 14
  end
    
  it "should return a non-nil, non-blank value for the slug keys in tags" do
    check_key_value_exists_for_all(@response, @data['tags'], 'slug')
  end
  
  it "should return an article tagged as 'review' with a tagType of 'classification'" do
    @data['tags'][4].should eql({"slug"=>"review", "tagType"=>"classification", "displayName"=>"Review"})
  end
  
  ["videoSeries",
    "regions"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in extra" do
      check_key(@response, @data['extra'], k)
    end
  end
  
  ["youtubeChannelIds",
    "legacyArticleIds"].each do |k|
    it "should return a non-nil, non-blank value for the #{k} key in refs" do
      check_key(@response, @data['refs'], k)
    end
  end
  
  ["encodingProfile",
    "watermarkProfile",
    "mezzanineUrl",
    "createdAt",
    "updatedAt"].each do |k|
    if k == "mezzanineUrl"
      it "should return a non-nil, non-blank value for the #{k} key in system", :prd => true do
        check_key(@response, @data['system'], k)
        puts "should not dosplay----------"
      end
    else
      it "should return a non-nil, non-blank value for the #{k} key in system" do
        check_key(@response, @data['system'], k)
        puts k
      end
    end
  end

end

##################################################################

##################################################################


