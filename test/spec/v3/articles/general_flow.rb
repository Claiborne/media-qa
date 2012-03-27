require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

#Client ID: 4e972e6be4b0a23ca6e1f2e6
#Secret:
#http://apicms.lan.ign.com/
# 85163bdb537ca8389dbb2ca552261247723699c4

#["authorization-config","playlists","read","authentication-user","authorization-client","entitlements-config","authentication-login","entitlements-set","videos","write","articles"]

def get_topaz_token
  # 85163bdb537ca8389dbb2ca552261247723699c4
end

def body_request
  {
  "metadata.headline"=>"Article Media-QA Test #{Random.rand(100000-900000)}",
  "metadata.articleType"=>"article",
  "metadata.authors"=>"Media QA"
  }.to_json
end

describe "V3 Articles API -- Create A Valid Article -- 10.92.218.21:8081/v3/articles?oauth_token={secret}", :spam => true do

  before(:all) do
    @url = "10.92.218.21:8081/v3/articles?oauth_token=#{get_topaz_token}"
    begin 
      @response = RestClient.post @url, body_request, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  it "should return a response of 200" do
    puts @response
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "shoud return an 'articleID' key" do
    puts @data
    @data.has_key?('articleID').should be_true
  end
  
  it "should return an 'articleID' value that is a 24-character hash" do
    @data['articleID'].match(/^[0-9a-f]{24,32}$/).should be_true
  end
  
end