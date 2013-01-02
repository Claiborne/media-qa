# encoding: utf-8

require 'rspec'
require 'pathconfig'
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

class ArticlesFe
  def article_pages

    not_new_review = {
        "matchRule"=>"matchAll",
        "rules"=>[
    {
        "field"=>"metadata.articleType",
        "condition"=>"is",
        "value"=>"article"
    },
    {
        "field"=>"tags",
        "condition"=>"containsNone",
        "value"=>"review"
    },
    {
        "field"=>"tags",
        "condition"=>"containsOne",
        "value"=>"news"
    }
    ],
        "startIndex"=>0,
        "count"=>20,
        "networks"=>"ign",
        "states"=>"published",
        "fields"=>["metadata.slug"]
    }.to_json

    articles_pages = []
    url = "http://apis.lan.ign.com/article/v3/articles/search?q=#{not_new_review}"
    url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    res = RestClient.get(url)
    articles = JSON.parse(res.body)
    article_count = 0
    articles['data'].each do |article|
      if article['content'].to_s.delete('^a-zA-Z').length > 0
        articles_pages << article['metadata']['slug']
        article_count += 1
      end
      break if article_count == 3
    end
    articles_pages
  end
end

ArticlesFe.new.article_pages.each do |article_slug|
%w(www uk au).each do |domain_locale|
describe "Article Page -- #{domain_locale} #{article_slug}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = @base_url+"/articles/2012/01/01/#{article_slug}"
    @pref_cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_home_open(@url,@pref_cooki)
    case domain_locale
      when 'www'
        @locale = 'US'
      when 'uk'
        @locale = 'UK'
      when 'au'
        @locale = 'AU'
      else
        Exception.new 'Unable to set locale variable'
    end
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@pref_cookie).should == domain_locale
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

end end end

############################################################################################
# Game Review

%w(/articles/2012/10/01/resident-evil-6-review).each do |review|
%w(www uk au).each do |domain_locale|
describe "New Review Article Page -- #{domain_locale} #{review}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "#@base_url#{review}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    case domain_locale
      when 'www'
        @locale = 'US'
      when 'uk'
        @locale = 'UK'
      when 'au'
        @locale = 'AU'
      else
        Exception.new 'Unable to set locale variable'
    end
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@cookie).should == domain_locale
  end

  it "should include at least one css file" do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500" do
    check_css_files(@doc)
  end

  context "Global Header Widget" do
    widget_evo_header
  end

  context "Global Footer Widget" do
    widget_global_footer
  end

  it "should include the share this widget once" do
    (@doc.css("div[class*='addthis_toolbox']").count == 1).should be_true
  end

  it "should include the discus comments widget once" do
    @doc.css('div#disqus_thread').count.should == 1
  end

  context "Header Image" do

    it "should contain an image" do
      check_have_an_img 'div#review-image'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#review-image'
    end

    it "should display the review's title" do
      @doc.css('h1#review-title').text.match(/Resident Evil 6 Review/).should be_true
    end

  end

  context "Header Video" do

    it "should be present" do
      @doc.at_css('div#review-promo div#video-play').should be_true
      @doc.at_css('div#review-promo div#video-container').should be_true
    end

    it "should insert the 'resident-evil-6-video-review' video" do
      @doc.at_css('div#review-promo div#video-container').attribute('data-video-url').to_s.match(/resident-evil-6-video-review/).should be_true
    end

  end

  context "Author ByLine" do

    it "should display the author's name" do
      @doc.css('div#review-creator div#creator-name a').text.match(/Richard George/).should be_true
    end

    it "should link the author's name to his profile" do
      @doc.css('div#review-creator div#creator-name a').attribute('href').to_s.should == "http://people.ign.com/bullseye2"
    end

    it "should link the author's avatar to his profile" do
      @doc.at_css('div#review-creator a.user-path').attribute('href').to_s.should == "http://people.ign.com/bullseye2"
      @doc.at_css('div#review-creator a.user-path img.user_image').should be_true
    end

    it "should display an avatar image" do
      check_for_broken_images 'div#review-creator'
    end

  end

  context "Left Rail Game Details" do

    it "should display the game's title" do
      @doc.css('div#review-object h2.object-name').text.match(/Resident Evil 6/).should be_true
    end

    it "should display the game's release data" do
      @doc.css('div#review-object div#object-releasedate').text.match(/October 2, 2012/).should be_true
    end

    it "should link to the game's object page" do
      @doc.css('div#review-object a').each do |link|
        link.attribute('href').to_s.match(/\/games\/resident-evil-6\/ps3-85710/).should be_true
      end
    end

    it "should display the game's description" do
      @doc.css('div#review-object p.object-description').text.delete('a-z').length.should > 10
    end

  end

  context "Left Rail Related Works" do

    it "should display the author's name" do
      @doc.css('div#related-works span.editor-says').text.should == 'Richard George Says'
    end

    it "should list three linked images" do
      @doc.css("div#related-works a img[src*='http']").count.should == 3
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#related-works'
    end

    it "should not contain any broken links" do
      check_for_broken_links 'div#related-works'
    end

  end

  context "Content Body" do

    it "should display the review's header" do
      @doc.css('h2#review-subtitle').text.match(/Bigger than ever, but not better./).should be_true
    end

    it "should display at least 100 characters of content" do
      @doc.css('div#article-content').text.delete('^a-z').length.should > 99
    end

    it "should not contain any broken links" do
      check_for_broken_links 'div#article-content'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#article-content'
    end

  end

  context "Content Verdict" do

    it "should display at least 100 characters of content" do
      @doc.css('div#review-verdict').text.delete('^a-z').length.should > 99
    end

  end

  context "Score Breakdown Box" do

    it "should display the correct object name and platform" do
      @doc.css('div#review-breakdown div.title-container').text.should == 'Resident Evil 6 on PlayStation 3, Xbox 360'
    end

    it "should link to the game's object page in the name" do
      @doc.css('div#review-breakdown span.object-title a').attribute('href').to_s.should == "http://xbox360.ign.com/objects/117/117995.html"
    end

    it "should display a score of 7.9" do
      @doc.css('div#review-breakdown div.score-container').text.match(/7.9/).should be_true
    end

    it "should display a description of 'GOOD'" do
      @doc.css('div#review-breakdown div.score-text').text.to_s.should == 'Good'
    end

    it "should display the score blurb" do
      @doc.css('div#review-breakdown div.blurb').text.match(/Resident Evil 6 might be the biggest RE game ever, but it struggles to be the best, lacking a coherent vision/).should be_true
    end

    it "should display the author's name" do
      @doc.css('div#review-breakdown div.byline').text.to_s.match(/Richard George/).should be_true
    end

    it "should display the publish date" do
      @doc.css('div#review-breakdown span.publish-date').text.to_s.should == '1 Oct 2012'
    end

    it "should display two pros and cons" do
      @doc.css('div.pros-cons-container ul.pros-cons-list').count.should == 2
      @doc.css('div.pros-cons-container li').count.should == 4
      check_display_text_for_each 'div.pros-cons-container li'
      i = 1
      @doc.css('div.pros-cons-container li span').each do |pm|
        if i < 3; pm.text.should == '+' else pm.text.should == "–" end
        i = i+1
      end
    end

  end

end end end

############################################################################################
# Movie Review

%w(/articles/2010/07/06/inception-review).each do |review|
%w(www uk au).each do |domain_locale|
describe "New Review Article Page -- #{domain_locale} #{review}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "#@base_url#{review}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    case domain_locale
      when 'www'
        @locale = 'US'
      when 'uk'
        @locale = 'UK'
      when 'au'
        @locale = 'AU'
      else
        Exception.new 'Unable to set locale variable'
    end
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@cookie).should == domain_locale
  end

  it "should include at least one css file" do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500" do
    check_css_files(@doc)
  end

  context "Global Header Widget" do
    widget_evo_header
  end

  context "Global Footer Widget" do
    widget_global_footer
  end

  it "should include the share this widget once" do
    (@doc.css("div[class*='addthis_toolbox']").count == 1).should be_true
  end

  it "should include the discus comments widget once" do
    @doc.css('div#disqus_thread').count.should == 1
  end

  context "Header Image" do

    it "should contain an image" do
      check_have_an_img 'div#review-image'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#review-image'
    end

    it "should display the review's title" do
      @doc.css('h1#review-title').text.match(/Inception Review/).should be_true
    end

  end

  context "Header Video" do

    it "should be present" do
      @doc.at_css('div#review-promo div#video-play').should be_true
      @doc.at_css('div#review-promo div#video-container').should be_true
    end

    it "should insert the 'resident-evil-6-video-review' video" do
      @doc.at_css('div#review-promo div#video-container').attribute('data-video-url').to_s.match(/inception-movie-video-review/).should be_true
    end

  end

  context "Author ByLine" do

    it "should display the author's name" do
      @doc.css('div#review-creator div#creator-name a').text.match(/Jim Vejvoda/).should be_true
    end

    it "should link the author's name to his profile" do
      @doc.css('div#review-creator div#creator-name a').attribute('href').to_s.should == "http://people.ign.com/StaxIGN"
    end

    it "should link the author's avatar to his profile" do
      @doc.at_css('div#review-creator a.user-path').attribute('href').to_s.should == "http://people.ign.com/StaxIGN"
      @doc.at_css('div#review-creator a.user-path img.user_image').should be_true
    end

    it "should display an avatar image" do
      check_for_broken_images 'div#review-creator'
    end

  end

  context "Left Rail Related Works" do

    it "should display the author's name" do
      @doc.css('div#related-works span.editor-says').text.should == 'Jim Vejvoda Says'
    end

    it "should list three linked images" do
      @doc.css("div#related-works a img[src*='http']").count.should == 3
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#related-works'
    end

    it "should not contain any broken links" do
      check_for_broken_links 'div#related-works'
    end

  end

  context "Content Body" do

    it "should display the review's header" do
      @doc.css('h2#review-subtitle').text.match(/Christopher Nolan follows up The Dark Knight with his best film yet./).should be_true
    end

    it "should display at least 100 characters of content" do
      @doc.css('div#article-content').text.delete('^a-z').length.should > 99
    end

    it "should not contain any broken links" do
      check_for_broken_links 'div#article-content'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#article-content'
    end

  end

  context "Content Verdict" do

    it "should display at least 100 characters of content" do
      @doc.css('div#review-verdict').text.delete('^a-z').length.should > 99
    end

  end

  context "Score Breakdown Box" do

    it "should display the correct object name and platform" do
      @doc.css('div#review-breakdown div.title-container').text.should == 'Inception on Movies'
    end

    it "should link to the movie's object page in the name" do
      @doc.css('div#review-breakdown span.object-title a').attribute('href').to_s.should == "http://movies.ign.com/objects/143/14322233.html"
    end

    it "should display a score of 10" do
      @doc.css('div#review-breakdown div.score-container').text.match(/10\s/).should be_true
    end

    it "should display a description of 'GOOD'" do
      @doc.css('div#review-breakdown div.score-text').text.to_s.should == 'Masterpiece'
    end

    it "should display the score blurb" do
      @doc.css('div#review-breakdown div.blurb').text.match(/Inception could very well be Nolan's masterpiece./).should be_true
    end

    it "should display the author's name" do
      @doc.css('div#review-breakdown div.byline').text.to_s.match(/Jim Vejvoda/).should be_true
    end

    it "should display the publish date" do
      @doc.css('div#review-breakdown span.publish-date').text.to_s.should == '5 Jul 2010'
    end

    it "should display four pros and zero cons" do
      @doc.css('div.pros-cons-container ul.pros-cons-list').count.should == 1
      @doc.css('div.pros-cons-container ul.pros-cons-list li').count.should == 4
      check_display_text_for_each 'div.pros-cons-container li'
      @doc.css('div.pros-cons-container ul.pros-cons-list li span').each do |plus|
        plus.text.should == "+"
      end
    end

  end

end end end

############################################################################################
# TV Review

%w(/articles/2012/10/04/south-park-raising-the-bar-review).each do |review|
%w(www uk au).each do |domain_locale|
describe "New Review Article Page -- #{domain_locale} #{review}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "#@base_url#{review}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    case domain_locale
      when 'www'
        @locale = 'US'
      when 'uk'
        @locale = 'UK'
      when 'au'
        @locale = 'AU'
      else
        Exception.new 'Unable to set locale variable'
    end
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@cookie).should == domain_locale
  end

  it "should include at least one css file" do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500" do
    check_css_files(@doc)
  end

  context "Global Header Widget" do
    widget_evo_header
  end

  context "Global Footer Widget" do
    widget_global_footer
  end

  it "should include the share this widget once" do
    (@doc.css("div[class*='addthis_toolbox']").count == 1).should be_true
  end

  it "should include the discus comments widget once" do
    @doc.css('div#disqus_thread').count.should == 1
  end

  context "Header Image" do

    it "should contain an image" do
      check_have_an_img 'div#review-image'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#review-image'
    end

    it "should display the review's title" do
      @doc.css('h1#review-title').text.match(/South Park: "Raising the Bar" Review/).should be_true
    end

  end

  context "Header Video" do

    it "should not be present" do
      @doc.at_css('div#review-promo div#video-play').should_not be_true
      @doc.at_css('div#review-promo div#video-container').should_not be_true
    end

  end

  context "Author ByLine" do

    it "should display the author's name" do
      @doc.css('div#review-creator div#creator-name a').text.match(/Max Nicholson/).should be_true
    end

    it "should link the author's name to his profile" do
      @doc.css('div#review-creator div#creator-name a').attribute('href').to_s.should == "http://people.ign.com/MaxNicholson"
    end

    it "should link the author's avatar to his profile" do
      @doc.at_css('div#review-creator a.user-path').attribute('href').to_s.should == "http://people.ign.com/MaxNicholson"
      @doc.at_css('div#review-creator a.user-path img.user_image').should be_true
    end

    it "should display an avatar image" do
      check_for_broken_images 'div#review-creator'
    end

  end

  context "Content Body" do

    it "should display the review's header" do
      @doc.css('h2#review-subtitle').text.match(/"We're done here. Set course for the set of Avatar 2."/).should be_true
    end

    it "should display at least 100 characters of content" do
      @doc.css('div#article-content').text.delete('^a-z').length.should > 99
    end

    it "should not contain any broken links" do
      check_for_broken_links 'div#article-content'
    end

    it "should not contain any broken images" do
      check_for_broken_images 'div#article-content'
    end

  end

  context "Content Verdict" do

    it "should display at least 100 characters of content" do
      @doc.css('div#review-verdict').text.delete('^a-z').length.should > 99
    end

  end

  context "Score Breakdown Box" do

    it "should display the correct object name and platform" do
      @doc.css('div#review-breakdown div.title-container').text.should == 'Raising the Bar on Tv-episodes'
    end

    it "should link to the game's object page in the name" do
      @doc.css('div#review-breakdown span.object-title a').attribute('href').to_s.should == "http://tv.ign.com/objects/144/144180.html"
    end

    it "should display a score of 8.7" do
      @doc.css('div#review-breakdown div.score-container').text.match(/8.7/).should be_true
    end

    it "should display a description of 'GREAT'" do
      @doc.css('div#review-breakdown div.score-text').text.to_s.should == 'Great'
    end

    it "should display the score blurb" do
      @doc.css('div#review-breakdown div.blurb').text.match(/South Park's "Raising the Bar" sets a new standard for Season 16, offering sharp satire and witty commentary./).should be_true
    end

    it "should display the author's name" do
      @doc.css('div#review-breakdown div.byline').text.to_s.match(/Max Nicholson/).should be_true
    end

    it "should display the publish date" do
      @doc.css('div#review-breakdown span.publish-date').text.to_s.should == '4 Oct 2012'
    end

    it "should display no pros or cons" do
      @doc.css('div.pros-cons-container ul.pros-cons-list').count.should == 0
      @doc.css('div.pros-cons-container li').count.should == 0
    end

  end

end end end

############################################################################################
# Old View, New Breakdown Box

%w(/articles/2012/10/04/dark-shadows-blu-ray-review).each do |review|
%w(www uk au).each do |domain_locale|
describe "New Review Article Page -- #{domain_locale} #{review}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "#@base_url#{review}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    case domain_locale
      when 'www'
        @locale = 'US'
      when 'uk'
        @locale = 'UK'
      when 'au'
        @locale = 'AU'
      else
        Exception.new 'Unable to set locale variable'
    end
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@cookie).should == domain_locale
  end

  it "should include at least one css file" do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500" do
    check_css_files(@doc)
  end

  context "Global Header Widget" do
    widget_evo_header
  end

  context "Global Footer Widget" do
    widget_global_footer
  end

  it "should include the share this widget twice" do
    (@doc.css("div[class*='addthis_toolbox']").count == 2).should be_true
  end

  it "should include the discus comments widget once" do
    @doc.css('div#disqus_thread').count.should == 1
  end

  context "Article Header" do

    it "should display the article header" do
      @doc.css('h1.article_title').text.should == 'Dark Shadows Blu-ray Review'
    end

    it "should display the article subtitle" do
      @doc.css('h2.article_subtitle').text.should == "Tim Burton's latest disappointment."
    end

  end

  context "Author Byline" do

    it "should display the author's name" do
      @doc.at_css('div.article_byLine div.article_author').text.should == 'by RL Shaffer'
    end

    it "should display the publish date" do
      @doc.at_css('div.article_byLine div.article_pub_date').text.should == ' October 4, 2012'
    end

  end

  context "Content Body" do

    it "should display at least 500 characters of content" do
      @doc.css('div.article_content').text.delete('^a-z').length.should > 499
    end

  end

  context "Content Verdict" do

    it "should display the verdict header" do
      @doc.css('div.articleVerdictHeader').text.should == 'The Verdict'
    end

    it "should display at least 100 characters of content" do
      @doc.css('div.articleVerdictText').text.delete('^a-z').length.should > 99
    end

  end

  context "Score Breakdown Box" do

    it "should display the correct object name and platform" do
      @doc.css('div.breakdown-box div.title-container').text.should == 'Dark Shadows on Blu-ray'
    end

    it "should link to the game's object page in the name" do
      @doc.css('div.breakdown-box span.object-title a').attribute('href').to_s.should == "http://bluray.ign.com/objects/138/138690.html"
    end

    it "should display a score of 5.3" do
      @doc.css('div.breakdown-box div.score-container').text.match(/5.3/).should be_true
    end

    it "should display a description of 'MEDIOCRE'" do
      @doc.css('div.breakdown-box div.score-text').text.to_s.should == 'Mediocre'
    end

    it "should display the score blurb" do
      @doc.css('div.breakdown-box div.blurb').text.match(/The Blu-ray looks and sounds great, but Dark Shadows is yet another misfire for Tim Burton./).should be_true
    end

    it "should display the author's name" do
      @doc.css('div.breakdown-box div.byline').text.to_s.match(/RL Shaffer /).should be_true
    end

    it "should display the publish date" do
      @doc.css('div.breakdown-box span.publish-date').text.to_s.should == '4 Oct 2012'
    end

    it "should display two pros and cons" do
      @doc.css('div.pros-cons-container ul.pros-cons-list').count.should == 2
      @doc.css('div.pros-cons-container li').count.should == 4
      check_display_text_for_each 'div.pros-cons-container li'
      i = 1
      @doc.css('div.pros-cons-container li span').each do |pm|
        if i < 3; pm.text.should == '+' else pm.text.should == "–" end
        i = i+1
      end
    end

  end

end end end