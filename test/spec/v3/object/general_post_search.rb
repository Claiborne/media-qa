require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'
require 'assert'

include Assert

########################### BEGIN REQUEST BODY METHODS #############################

def release_search_smoke
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

def should_return_405(url)
  RestClient.post url, release_search_smoke, :content_type => "application/json"
end

############################ BEGIN SPEC #################################### 


describe "V3 Object API -- Post Search for Published 360 Releases: #{release_search_smoke}", :error => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = Configuration.new
    @url = "http://#{@config.options['baseurl']}/releases/search"
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  it "should return 405" do
    expect { should_return_405(@url) }.to raise_error(RestClient::MethodNotAllowed)
  end
  
end