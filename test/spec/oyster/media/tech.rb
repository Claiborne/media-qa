require 'rspec'
require 'configuration'
require 'Nokogiri'
require 'open-uri'
require 'tech_nav'

include TechNav

##TODO soical touchpoint follow button

describe "tech frontend - tech home page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should not be missing the blogroll widget", :stg => true do
    @doc.at_css('div#ign-blogroll').should be_true
  end
  
  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  it "should not be missing the discover more widget", :stg => true do
    @doc.at_css('div.slider-holder div.subHeaderContainer').should be_true
  end
end

@topic = return_tech_nav
@topic.each do |topic|
describe "tech frontend - tech/#{topic} page" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech/#{topic}"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
end
end

describe "tech frontend - v2 article page" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/09/13/article-test-page-sept-2011"
    @doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should not be missing the global header widget", :stg => true do
    @doc.at_css('div#ign-header').should be_true
  end
  
  it "should not be missing the global footer widget", :stg => true do
    @doc.at_css('div#ignFooter-container').should be_true
  end
  
  it "should not be missing the two share this widgets", :stg => true do
    (@doc.css("div[class*='shareThis addthis_toolbox']").count == 2).should be_true

  end
  
  it "should not be missing the discus comments widget", :stg => true do
    @doc.at_css('div#disqus_thread').should be_true
  end
  
  it "should not be missing the pagination widget when more than one page exists", :stg => true do
    @doc.at_css('div.pager_list').should be_true
  end
  
  it "should not display the pagination widget when only one page exists", :stg => true do
    Nokogiri::HTML(open("http://#{@config.options['baseurl']}/articles/2011/08/24/report-iphone-5-coming-to-sprint")).at_css('div.pager_list').should be_false
  end
end