require 'rspec'
require 'configuration'
require 'Nokogiri'
require 'open-uri'
require 'tech_nav'
require 'widget/blogroll_v2_articles'
require 'widget/discover_more'
require 'rest_client'
require 'json'

include TechNav
include Blogrollv2Articles
include DiscoverMore

describe "tech frontend - link checker" do

  before(:all) do
    #Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    #@config = Configuration.new
    #@page = "http://#{@config.options['baseurl']}/tech"
    #@doc = Nokogiri::HTML(open(@page))
  end

  before(:each) do
    
  end

  after(:each) do

  end
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = Nokogiri::HTML(open(@page))
@doc.css('a').each do |link|
  it "should check all links #{link.attribute('href')}" do
      current_link = link.attribute('href')
      if current_link.to_s.match(/http/)
        puts current_link
        response = RestClient.get current_link.to_s
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
  end
end
end