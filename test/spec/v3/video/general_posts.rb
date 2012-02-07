require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'time'
require 'assert'

include Assert

describe "V3 Video API: Search Using Post Smoke Test" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_vid.yml"
    @config = Configuration.new
    
    @body = {
    "matchRule"=>"matchAll",
    "rules"=>[
      {
         "condition"=>"is",
         "field"=>"objectRelations.legacyId",
         "value"=>"872155"
      }
    ],
    "startIndex"=>0,
    "count"=>25,
    "networks"=>"ign",
    "prime"=>"false",
    "states"=>"published"
    }.to_json
    
    @url = "http://#{@config.options['baseurl']}/v3/videos/search"
    puts @url
    begin 
     @response = RestClient.post @url, @body, :content_type => "application/json"
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

end



