require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'json'
require 'open_page'
require 'fe_checker'
require 'widget/evo_header'
require 'widget/global_footer'
require 'widget/wiki_updates'
require 'widget/discover_more'
require 'widget/video_interrupt'
require 'widget/object_score'

include FeChecker
include OpenPage
include EvoHeader
include GlobalFooter
include WikiUpdates
include DiscoverMore
include VideoInterrupt
include ObjectScore

Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
@setup_config = Configuration.new
@setup_page = "http://#{@setup_config.options['baseurl']}/"
@setup_doc = nokogiri_not_301_open(@setup_page)
@articles_pages = []
i = 0
@setup_doc.css('div.blogrollContainer a.listElmnt-storyHeadline').each do |article_link|
  if i > 2; break; end
  if article_link.attribute('href').to_s.match(/www.ign.com\/articles/)
    @articles_pages << article_link.attribute('href').to_s
    i+=1
  end
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
    widget_evo_header
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
  
  it "should display the author's name in the top byline", :smoke => true do
    @doc.at_css('div.article_byLine div.article_author').text.delete('^a-zA-Z').length.should > 2
  end
  
  it "should display the date in the byline", :smoke => true do
    @doc.at_css('div.article_byLine div.article_pub_date').text.delete('^a-zA-Z').length.should > 0
  end
  
  it "should display content", :smoke => true do
    @doc.css('div.article_content p').text.delete('^a-zA-Z').length.should > 0
  end
  
  context "Video Interrupt Widget" do
  
    widget_video_interrupt
  
  end

end
end

#########################################################

describe "Review Article Page -- http://www.ign.com/articles/2011/10/17/apple-iphone-4s-review", :prd => true do
  
  before(:all) do
    @doc = nokogiri_not_301_open('http://www.ign.com/articles/2011/10/17/apple-iphone-4s-review')
  end

  before(:each) do
   
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
  end
  
  it "should incude the scorebox" do
    @doc.at_css('div.articleBreakdownBox').should be_true  
  end
  
  it "should include a numberic score" do
    @doc.css('div.articleBreakdownBox div.scorebox_breakdownOverallScore').text.delete('^0-9').length.should > 0
  end
  
  it "should include a score description" do
    @doc.css('div.articleBreakdownBox div.scorebox_breakdownOverallText').text.delete('^a-z').length.should > 0
  end
  
end
