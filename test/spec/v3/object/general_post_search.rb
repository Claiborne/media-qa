require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

########################### BEGIN REQUEST BODY METHODS #############################

module V3ObjectGeneralPostSearch
  def self.release_search_smoke
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

  def self.should_return_405(url)
    RestClient.post url, release_search_smoke, :content_type => "application/json"
  end
end

############################ BEGIN SPEC #################################### 


describe "V3 Object API -- Post Search for Published 360 Releases: #{V3ObjectGeneralPostSearch.release_search_smoke}", :error => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/releases/search"
  end

  before(:each) do

  end

  after(:each) do
    
  end
  
  after(:all) do

  end
  
  it "should return 405" do
    expect { V3ObjectGeneralPostSearch.should_return_405(@url) }.to raise_error(RestClient::MethodNotAllowed)
  end
  
end