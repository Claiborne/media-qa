require 'rest_client'
require 'json'

def get_stage_topaz_token
  '109dbea287470edeabd67c0ec53e29cf9318580b'
end

def body_request
  {
    "metadata" => {
      "headline"=>"Media QA Test Blog A11",
      "articleType"=>"post",
      "state"=>"published",
      "blogName"=>"slyclaiborne",
      "networks"=>["ign"],
    },
    "authors" => [
        {
          "name"=>"slyclaiborne"
        }
    ],
    "content" => ["Test Content Body. Media QA Test Blog A11"]
  }.to_json
end


@url = "http://10.92.218.21:8081/v3/articles?oauth_token=#{get_stage_topaz_token}"

@response = RestClient.post @url, body_request, :content_type => "application/json"

puts @response.code
puts @response






=begin
require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'var_helper'

include Assert

def get_stage_topaz_token
  'ed4063ae614773398a945dc35962e599b511fe0e'
end

#TODO:
# get_stage_topaz_token lib helper method

def body_request
  {
    "metadata" => {
      "headline"=>"Media QA Test Article #{Random.rand(100000-999999)}",
      "articleType"=>"article",
      "state"=>"published"
    },
    "authors" => [
        {
          "name"=>"Media-QA"
        }
    ],
    "content" => ["Test Content Body. Media QA Test Article..."]
  }.to_json
end

##################################################################

describe "V3 Articles API -- Create An Article -- POST 10.92.218.21:8081/v3/articles?oauth_token={token}", :write => true do

  before(:all) do
    @url = "http://10.92.218.21:8081/v3/articles?oauth_token=#{get_stage_topaz_token}"
    begin 
      @response = RestClient.post @url, body_request, :content_type => "application/json"
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
    sleep 3
  end
  
  it "should return a response of 200" do
    @response.code.should eql(201)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end
  
  it "shoud return an 'articleID' key" do
    @data.has_key?('articleId').should be_true
  end
  
  it "should return an 'articleID' value that is a 24-character hash" do
    @data['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    VarHelper.set_helper_var1(@data['articleId'].to_s)
    puts @data['articleId'].to_s
  end
  
end
=end