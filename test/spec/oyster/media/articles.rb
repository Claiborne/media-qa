require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'json'
require 'open_page'
require 'fe_checker'
require 'widget/global_header'
require 'widget/global_footer'
require 'widget/wiki_updates'
require 'widget/discover_more'
require 'widget/video_interrupt'

include FeChecker
include OpenPage
include GlobalHeader
include GlobalFooter
include WikiUpdates
include DiscoverMore
include VideoInterrupt

Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_hubs.yml"
@setup_config = Configuration.new
@setup_page = "http://#{@setup_config.options['baseurl']}/tech"
@setup_doc = nokogiri_not_301_open(@setup_page)
@articles_pages = []
i = 0
@setup_doc.css('div.blogrollContainer h3 > a').each do |article_link|
  if i >= 3; break; end
  @articles_pages << article_link.attribute('href').to_s
  i+=1
end

@articles_pages.each do |article|
describe "Article Page -- #{article}" do
  
  doc = nokogiri_not_301_open(article)
  
  before(:all) do
    @doc = doc
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

  context "Global Header Widget" do
    widget_global_header
  end

  context "Global Footer Widget" do
    widget_global_footer
  end
  
  it "should include two share this widgets", :smoke => true do
    (@doc.css("div[class*='addthis_toolbox']").count == 2).should be_true
  end
  
  it "should include the discus comments widget once", :smoke => true do
    @doc.css('div#disqus_thread').count.should == 1
  end
  
  # BAD HACK
  # if article topic is lifestyle, skip Wiki Updates Widget
  unless doc.css('div.vn-container li.vn-categoryItem a').attribute('href').to_s.match('/lifestyle')
    context "Wiki Updates Widget" do
      
      widget_wiki_updates
    
    end
  end

  it "should not display the pagination widget when only one page exists" do
    @doc.at_css('div.pager_list').should be_false
  end
  
  context "Discover More Widget" do
  
    widget_discover_more
  
  end
  
  context "Video Interrupt Widget" do
  
    widget_video_interrupt
  
  end
  
  context "Vert Nav Widget" do
    
    widget_discover_more
    
    it "should include all components", :smoke => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      @doc.css('div.vn-container ul li.vn-navItem a').count.should > 3
    end
  end

end
end
