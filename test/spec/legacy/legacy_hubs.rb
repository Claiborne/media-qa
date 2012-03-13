require 'rspec'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'widget/global_header'
require 'widget/global_footer'
require 'widget/legacy_cover_stories'
require 'widget/legacy_blogroll'

include FeChecker
include OpenPage
include GlobalFooter
include GlobalHeader
include LegacyCoverStories
include LegacyBlogroll

@hubs = [
"http://www.ign.com",
"http://ps3.ign.com",
"http://xbox360.ign.com",
"http://wii.ign.com",
"http://pc.ign.com",
"http://ds.ign.com",
"http://vita.ign.com",
"http://wireless.ign.com",
"http://movies.ign.com",
"http://tv.ign.com",
"http://comics.ign.com",
"http://music.ign.com",
"http://stars.ign.com",
"http://uk.ign.com",
"http://uk.ps3.ign.com",
"http://uk.xbox360.ign.com",
"http://uk.wii.ign.com",
"http://uk.pc.ign.com",
"http://uk.ds.ign.com",
"http://uk.vita.ign.com",
"http://uk.wireless.ign.com",
"http://uk.movies.ign.com",
"http://uk.tv.ign.com",
"http://uk.comics.ign.com",
"http://uk.music.ign.com",
"http://uk.stars.ign.com",
"http://au.ign.com",
"http://au.ps3.ign.com",
"http://au.xbox360.ign.com",
"http://au.wii.ign.com",
"http://au.pc.ign.com",
"http://au.ds.ign.com",
"http://au.vita.ign.com",
"http://au.wireless.ign.com",
"http://au.movies.ign.com",
"http://au.tv.ign.com",
"http://au.comics.ign.com",
"http://au.music.ign.com",
"http://au.stars.ign.com",
]

@hubs.each do |hub|
  
describe "#{hub}:" do

  before(:all) do
    @page = hub.to_s
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
  
  context "Global Header Widget:" do
    widget_global_header
  end
  
  context "Global Footer Widget:" do
    widget_global_footer
  end
  
  context "Cover Stories Widget:" do
    widget_legacy_cover_stories
  end
  
  context "Blogroll" do
    widget_legacy_blogroll
  end
  
end# end describe
end# end hub interation


