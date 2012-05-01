require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'

include OpenPage
include FeChecker

describe "Released GOB Page -- /games/mass-effect-3/xbox-360-14235014" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/mass-effect-3/xbox-360-14235014"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
end

####################################################################################

describe "Unreleased GOB Page -- /games/halo-4/xbox-360-110563" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/halo-4/xbox-360-110563"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should return 200", :smoke => true do
  end
  
  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
end