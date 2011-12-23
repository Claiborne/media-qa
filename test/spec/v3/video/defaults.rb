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
  
  it "should return an hash with six indices" do
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
    it "should return videos with a #{k} key", :test => true do
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




