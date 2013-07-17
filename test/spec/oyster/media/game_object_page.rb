require 'rspec'
require 'pathconfig'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'json'

include OpenPage
include FeChecker

#darksiders-ii/xbox-360-14336768 heavenly-sword/ps3-700186 littlebigplanet/vita-98907 nhl-13/xbox-360-128182 metal-gear-solid-844505/gbc-13458 call-of-duty-black-ops-ii/pc-126314 professional-fishermans-tour-big-bass-open/3ds-87854

#%w(halo-4/xbox-360-110563).each do |url_slug|
#%w(www).each do |domain_locale|

%w(halo-4/xbox-360-110563 the-last-of-us/ps3-123980).each do |url_slug|
%w(www uk au).each do |domain_locale|

describe "Oyster Game Object Pages - #{domain_locale}.ign.com/games/#{url_slug}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "http://#{@base_url}/games/#{url_slug}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    @legacy_id = url_slug.match(/[0-9]{1,8}\z/)
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

    #articles = ({"matchRule"=>"matchAll","count"=>10,"rules"=>[{"field"=>"metadata.articleType","condition"=>"is","value"=>"article"},{"field"=>"legacyData.objectRelations","condition"=>"is","value"=>"#{@legacy_id}"},{"field"=>"categoryLocales","condition"=>"contains","value"=>"#{@locale.downcase}"}]}.to_json).to_s
    articles = ({"matchRule"=>"matchAll","count"=>10,"rules"=>[{"field"=>"metadata.articleType","condition"=>"is","value"=>"article"},{"field"=>"legacyData.objectRelations","condition"=>"is","value"=>"#{@legacy_id}"}]}.to_json).to_s
    articles = articles.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    videos =    ({"matchRule"=>"matchAll","prime"=>false,"networks"=>"ign","count"=>3,"startIndex"=>0,"states"=>"published","rules"=>[{"field"=>"objectRelations.legacyId","condition"=>"is","value"=>@legacy_id}],"fields"=>["metadata"]}.to_json).to_s
    videos = videos.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    images = ({"matchRule"=>"matchAll","rules"=>[{"field"=>"legacyData.objectRelations","condition"=>"is","value"=>@legacy_id},{"field"=>"tags","condition"=>"containsOne","value"=>"gallery"}],"startIndex"=>0,"count"=>1,"sortBy"=>"system.createdAt","dateType"=>"system.createdAt","states"=>"published"}.to_json).to_s
    images = images.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin
      @images = (JSON.parse RestClient.get("http://apis.lan.ign.com/image/v3/images/search?q=#{images}").body)['data'][0]
    rescue
      @images = "ERROR_GETTING_IMAGES"
    end
    @articles = (JSON.parse RestClient.get("http://apis.lan.ign.com/article/v3/articles/search?q=#{articles}").body)  
    @videos = (JSON.parse RestClient.get("http://apis.lan.ign.com/video/v3/videos/search?q=#{videos}").body)
    @data = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/releases/legacyId/#@legacy_id?metadata.region=#@locale").body)['data'][0]
    @us_data = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/releases/legacyId/#@legacy_id?metadata.region=US").body)['data'][0]
    @all_data = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/releases/legacyId/#@legacy_id").body)

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_locale(@base_url,@cookie).should == domain_locale
  end

  context "Object Header" do

    it "should display text" do
      check_display_text('div.contentHeaderNav')
    end

    it "should have a link" do
      check_have_a_link('div.contentHeaderNav')
    end

    it "should display the same title name the object API returns" do
      @doc.css('h1.contentTitle').text.strip.should == @data['metadata']['name']
    end

    it "should link to #{url_slug} in the title" do
      @doc.css('h1.contentTitle a').attribute('href').to_s.match(url_slug).should be_true
    end

    it "should display the same platform the object API returns" do
      case @data['hardware']['platform']['metadata']['name']
      when 'PlayStation 3'
        @doc.css('div.contentPlatformsText').text.match(/Xbox 360/)
      when 'Xbox 360'
        @doc.css('div.contentPlatformsText').text.match(/PS3/)
      else
        @doc.css('div.contentPlatformsText').text.delete('^a-zA-Z')
      end
    end

    it "should display the same release data the object API returns" do
      @doc.css('div.releaseDate strong').text.should == @data['metadata']['releaseDate']['display']
    end

    it "should include the follow social touch-point" do
      @doc.at_css('div.myIgnFollowInstance').should be_true
    end

    if @locale == 'US'
      it "should include the GameStop link" do
        @doc.at_css("div[class='contentHead-gameStop contentHead-gameStopPrice'] a").should be_true
      end
    end

    it "should include the Facebook Like button" do
      @doc.at_css('div.fb-like iframe').attribute('src').to_s.match(/facebook.com/).should be_true
    end

  end

  context "Object Navigation" do

    it "should have at least eight links" do
      @doc.css('ul.contentNav li a').count.should > 7
    end

    it "should display text for each link" do
      check_display_text_for_each('ul.contentNav li a')
    end

    %w(games wikis videos images faqs cheats articles boards).each do |link|
      it "should link to #{link}" do
        @doc.at_css("ul.contentNav li a[href*='"+link.to_s+"']").should be_true
      end
    end

    it "should link to /games/#{url_slug}" do
      @doc.at_css("ul.contentNav li a[href*='games/#{url_slug}']").should be_true
    end

    it "should not contain any broken links" do
      check_links_not_301_home('ul.contentNav')
    end

  end

  context "Highlight Area" do

    it "should display the same image the object API returns" do
      if @data['legacyData'].has_key?('boxArt')
        box_art = []
        @data['legacyData']['boxArt'].each do |art|
          box_art << art['url']
        end
        box_art.include?(@doc.css('div.mainBoxArt img').attribute('src').to_s).should be_true
      elsif @us_data['legacyData'].has_key?('boxArt')
        box_art = []
        @us_data['legacyData']['boxArt'].each do |art|
          box_art << art['url']
        end
        box_art.include?(@doc.css('div.mainBoxArt img').attribute('src').to_s).should be_true

      else
      end
    end

    it "should display a highlight image" do
      @doc.css("div[class*='contentBackground grid_16']").attribute('style').to_s.match(/http/).should be_true
    end

    it "should display and link to a preview article if one exists and no review exists" do
      review = false
      @all_data['data'].each do |release|
        if release.has_key?('legacyData')
          if release['legacyData'].has_key?('reviewUrl'); review = true end
        end
      end
      if review == false
        @doc.css('div.reviewTitle-wrapper h3').text.match(/Preview/).should be_true
        @doc.css('div.reviewTitle-wrapper h3 a').attribute('href').to_s.match('articles').should be_true
        check_return_200_without_301_to_home @doc.css('div.reviewTitle-wrapper h3 a').attribute('href').to_s
        @doc.css('div.articlesubHeadline span.text').text.delete('^a-z').length.should > 1
      end
    end

    it "should display and link to the review article if one exists, including box art image" do
      review = false
      @all_data['data'].each do |release|
        if release.has_key?('legacyData')
          if release['legacyData'].has_key?('reviewUrl'); review = true end
        end
      end
      if review == true
        @doc.css('div.reviewTitle-wrapper h3').text.match(/Review/).should be_true
        @doc.css('div.reviewTitle-wrapper h3 a').attribute('href').to_s.match('articles').should be_true
        RestClient.get @doc.css('div.reviewTitle-wrapper h3 a').attribute('href').to_s
        @doc.css('div.articlesubHeadline span.text').text.delete('^a-z').length.should > 1
        @doc.css('div.scoreBox-score a').text.delete('^0-9').length.should > 0
        @doc.css('div.scoreBox-score a').attribute('href').to_s.match('articles').should be_true
        RestClient.get @doc.css('div.scoreBox-score a').attribute('href').to_s
      end
    end

    it "should display a link to the review or preview video if one exists" do
      video_review = ""
      @all_data['data'].each do |vid|
         if vid['legacyData'].has_key?('videoReviewUrl'); video_review = true end
      end

      video_preview = ""
      @all_data['data'].each do |vid|
        if vid['legacyData'].has_key?('videoTrailerUrl'); video_preview = true end
      end

      if video_review != ""
        @doc.css('div.highlight-links a').attribute('href').to_s.match(/\/videos\//).should be_true
        @doc.css('div.highlight-links a').text.match(/Review/).should be_true
      end

      if video_preview != ""
        prev = true
        @all_data['data'].each do |vid|
          if vid['legacyData'].has_key?('reviewUrl'); prev = "" end
        end

        if prev != ""
          @doc.css('div.highlight-links a').attribute('href').to_s.match(/\/videos\//).should be_true
          @doc.css('div.highlight-links a').text.match(/Preview/).should be_true
        end
      end

    end

  end

  context "Wiki Area" do

    it "should display at least four thumbs" do
      @doc.css('div.wikiToC-image img').count.should > 3
      check_for_broken_images('div.wikiToC-image')
    end

    it "should display at least four wiki titles" do
      @doc.css('a.wikiToC-title').count.should > 3
      @doc.css('a.wikiToC-title').text.delete('^a-z').length.should > 0
    end

  end

  context "Latest Stories" do
=begin
     it "should display the same articles as the article API" do
       fe_slugs = []; api_slugs = []
       @doc.css('ul.updatesList h3 a.articleTitle').each do |article|
         fe_slugs << article.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s
       end
       @articles['data'].each do |article|
        api_slugs << article['metadata']['slug']
       end
       fe_slugs.should == api_slugs
     end
=end
     it "should display the same articles as the article API" do
       fe_headlines = []; api_headlines = []
       @doc.css('ul.updatesList h3 a.articleTitle').each do |article|
         fe_headlines << article.text
       end
       @articles['data'].each do |article|
        api_headlines << article['metadata']['headline']
       end
       fe_headlines.count.should > 0
       fe_headlines.should == api_headlines
     end

    context "View All Stories Button" do

      it "should link to 'articles/games/#{url_slug}'" do
        @doc.css("a.articleButton[href*='articles']").attribute('href').to_s.match(/articles\/games\/#{url_slug}/).should be_true
      end

      it "should not 404 when clicked" do
        check_return_200_without_301_to_home @base_url.to_s+"/"+@doc.css("a.articleButton[href*='articles']").attribute('href').to_s
      end

    end

  end

  context "Latest Videos" do

    it "should display the same videos as the video API returns" do
      fe_slugs = []; api_slugs = []
      @doc.css('div.ign-latestVideos a').each do |video|
        fe_slugs << video.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s
      end
      @videos['data'].each do |video|
        api_slugs << video['metadata']['slug']
      end
      fe_slugs.should == api_slugs
    end

    it "should display three thumbnails" do
      @doc.css('div.ign-latestVideos img.latestVideo-thumbnail').count.should == 3
      check_for_broken_images('div.latestVideo')
    end

  end

  context "Latest Image" do

    it "should display an image" do
      RestClient.get @doc.css('div.latestImage img.latestImage-thumbnail').attribute('src').to_s
    end

    it "should display the same image as the image API returns" do
      @doc.css('div.latestImage img.latestImage-thumbnail').attribute('src').to_s == @images['asset']['url'].gsub(/_[^_]{1,}\z/,"")
    end

    it "should link to the image gallery page" do
      @doc.css('div.latestImage a').attribute('href').to_s.match(/\/images\/games\/#{url_slug}/)
    end

  end

  context "Games You May Like" do

    it "should display six games" do
      @doc.css("div.gamesYouMayLike_content div.gamesYouMayLike-name a").count.should == 6
      @doc.css("div.gamesYouMayLike_content div.gamesYouMayLike-name a").each do |game|
        game.text.delete('^a-zA-Z').length.should > 0
      end
    end

  end

  context "About This Game" do

    it "should display summary content" do
      check_display_text "div#summary div.gameInfo"
      check_display_text "div#summary div[class='gameInfo-list leftColumn']"
      check_display_text "div#summary div.gameInfo-list"
    end

  end


end #end describe
end;end #end url_slug and domain_locale iteration
