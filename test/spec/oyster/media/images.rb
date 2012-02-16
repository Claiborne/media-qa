require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'

include OpenPage

describe "Images HomePage:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"########change this
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/images"
    puts @page
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should  301 to /index/images.html", :smoke => true do
    RestClient.get(@page) { |response, request, result, &block|
    ["http://www.ign.com/index/images.html","http://www.ign.com/index/images.html/"].include?(response.headers[:location].to_s).should be_true }
  end
  
end

describe "Images Gallery:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"########change this
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/images/games/metal-gear-solid-4-guns-of-the-patriots-ps3-714044"
    puts @page
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
  end
  
  it "should contain header text 'Metal Gear Solid 4 Images'" do
    @doc.css('h1.contentHeader').text.should == 'Metal Gear Solid 4 Images'
  end
  
  it "should display 20 images", :smoke => true do
    @doc.css('div.imageGalleryThumb img').count.should == 20
    @doc.css('div.imageGalleryThumb img').each do |img|
      img.attribute('src').to_s.match(/http/).should be_true
    end
  end
  
  it "should "
  
  it "should contain pagination", :smoke => true do
    
  end
  
end


