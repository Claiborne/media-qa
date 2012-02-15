require 'rspec'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
=begin

describe "Images HomePage:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/images"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
    check_return_200_without_301_to_home(@page)
  end
  
end
=end