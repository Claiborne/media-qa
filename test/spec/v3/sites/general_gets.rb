require 'rspec'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Sites API -- GET to /sites" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_sites.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/sites"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
    @prd_slugs = %w(emailpreferences-ign gamestats gamespy corp-ign m-ie-ign ign ie-ign crossassault-ign au-ign m-ign m-uk-ign m-au-ign m-ca-ign ca-ign uk-ign www-ign my-ign people-ign s-ign)
  end
  
  it "should return 200" do
    check_200 @response
  end
  
  it "should return 19 sites" do
    @data.count.should == 19
  end
  
  it "should return the appropriate sites" do
    slugs = []
    @data.each do |s|
      slugs << s['slug']
    end
    slugs.should =~ @prd_slugs
  end
  
end

