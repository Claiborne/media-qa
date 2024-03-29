require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'time'
require 'open_page'; include OpenPage
require 'phantom_helpers/video_player_page_helper'; include VideoPlayerPageHelper
require 'widget-plus/related_videos'; include RelatedVideos
require 'widget-plus/add_this'; include AddThis
require 'widget-plus/disqus'; include Disqus
require 'widget-plus/object_details'; include ObjectDetails
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'widget-plus/global_footer'; include GlobalFooter

%w(www uk au).each do |locale|
get_latest_videos(2).each do |video_page|
describe "Video Player Page -- #{locale.upcase} #{video_page}", :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/phantom.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
    @browser_config = BrowserConfig.new
    DataConfig.config_path = File.dirname(__FILE__) + "/../../config/v3_video.yml"
    @data_config = DataConfig.new

    @page = "http://#{@config.options['baseurl']}#{video_page}".gsub('//www',"//#{locale}")
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym

    @wait = Selenium::WebDriver::Wait.new(:timeout => 7)

    data_response = RestClient.get "http://#{@data_config.options['baseurl']}/v3/videos/slug/#{video_page.match(/[^\/]{2,}$/)}"
    @video_data = JSON.parse(data_response.body)

    case locale
      when 'uk'
        @selenium.get "http://uk.ign.com/?setccpref=UK"
      when 'au'
        @selenium.get "http://au.ign.com/?setccpref=AU"
      else
    end

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open #{video_page} in #{ENV['env']}" do
    @selenium.get @page
    @selenium.current_url.should == @page
  end

  context "Global Header and Nav Widget" do
    check_global_header_nav
  end

  it "should display the IGN video player once" do
    @selenium.find_elements(:css => "object#IGNPlayer").count.should == 1
    @selenium.find_element(:css => "object#IGNPlayer").displayed?.should be_true
  end

  it "should display the correct video title" do
    title = @selenium.find_element(:css => "div.video_details div.video_title")
    duration = @selenium.find_element(:css => "div.video_details div.video_title span.video-duration")
    date = @selenium.find_element(:css => "div.video_details div.video_title div.sub-details")

    title.displayed?.should be_true

    title = title.text.gsub(duration.text,"").gsub(date.text,"").chomp.rstrip.downcase.gsub(/ +/, ' ')
    title.should == get_api_title(@video_data).gsub(/ +/, ' ')
  end

  it "should display the duration" do
    duration = @selenium.find_element(:css => "div.video_details div.video_title span.video-duration")
    duration.displayed?.should be_true
    duration.text.match(/[0-9]{1,2}:[0-9]{2}/).should be_true
  end

  it "should display include the medrec elements" do
    @selenium.find_element(:css => "span[id='300x250slot'] form").should be_true
    @selenium.find_element(:css => "span[id='300x250slot'] span").should be_true
  end

  context "Video Playlist" do

    it "should display the navigation once" do
      @selenium.find_elements(:css => "div.video_playlist_selector").count.should == 1
      @selenium.find_element(:css => "div.video_playlist_selector div").displayed?.should be_true
    end

    it "should display the playlist once" do
      @selenium.find_elements(:css => "div#video_playlist ul").count.should == 1
      @wait.until { @selenium.find_element(:css => "div#video_playlist ul").displayed? }
    end

    it "should correctly display the navigation text" do
      nav_text = ['MUST WATCH', 'RELATED','IGN SHOWS', 'REVIEWS', 'TRAILERS']
      items = @selenium.find_elements(:css => "div.video_playlist_selector a.video_playlist_button span.item")
      items.count.should.should == 5
      items.each_with_index do |val, index|
        val.text.should == nav_text[index]
      end
    end

    it "should have one link to the e-mail subscription page in the nav" do
      @selenium.find_elements(:css => "div.video_playlist_selector div.item-subscribe a").count.should == 1
      subscribe = @selenium.find_element(:css => "div.video_playlist_selector div.item-subscribe a")
      subscribe.displayed?.should be_true

      subscribe_page = 'https://mail.ign.com/subscriptions/ign.php'

      subscribe.attribute("href").should == subscribe_page
      rest_client_not_301_home_open subscribe_page
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should highlight Must Watch videos in the nav by default" do
      selected = @selenium.find_element(:css => "div.video_playlist_selector span.item-container")
      selected.attribute('class').to_s.match(/container-selected/).should be_true
      selected.text.should == 'MUST WATCH'
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Must Watch videos by default" do
      @selenium.find_elements(:css => "ul#videos-list li a").count.should > 9
      @selenium.find_elements(:css => "ul#videos-list li a").each do |a|
        #a.attribute('href').to_s.match(/ign.com\/videos\/\d{4}\/\d{2}\/\d{2}\/./).should be_true
        begin
          a.attribute('href').to_s.match(/api.taboola.com/).should be_true
          a.attribute('href').to_s.match(/ign-ign/).should be_true
        rescue => e
          raise "Expected match api.taboola.com && ign-ign. Got #{a.attribute('href')}"
        end
        a.text.delete('^a-zA-Z').length.should > 0
      end
    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

    it "should highlight Related videos when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector span.item-container span[data-type='related']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector span[class='item-container container-selected'] span").attribute('data-type').to_s.should == 'related'
    end

    it "should display Related Videos when clicked" do
      # GET RELATED VIDEOS
      related_videos_response = RestClient.get "http://#{@data_config.options['baseurl']}/v3/videos/related/#{@video_data['videoId']}"
      related_videos = JSON.parse(related_videos_response.body)

      # IF RELATED VIDEOS NOT ENOUGH, GET OTHER VIDEOS TO FILL
      fe_count = @selenium.find_elements(:css => "ul#videos-list li").count
      if related_videos['data'].count < fe_count
        body = {
            :rules=>[
                {
                    :field=>"category",
                    :condition=>"is",
                    :value=>"ign_all"
                }
            ],
            :matchRule=>"matchAll",
            :prime=>false,
            :startIndex=>0,
            :count=>(fe_count - related_videos['data'].count),
            :networks=>"ign",
            :regions=>["US"]
        }.to_json
        generic_videos_response = RestClient.get "http://#{@data_config.options['baseurl']}/v3/videos/search?q=#{body}".gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
        generic_videos = JSON.parse(generic_videos_response.body)
      end

      ## COMPARE TITLES ##

      # STORE TITLES FROM API
      if related_videos['data'].count < fe_count
        api_titles = get_api_titles(related_videos)+get_api_titles(generic_videos)
      else
        api_titles = get_api_titles(related_videos)
      end

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip.gsub(/\s{2,}/, ' ')
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 3
      api_titles.length.should > 9
      fe_titles.length.should > 9

      ## COMPARE LINK ##

      # STORE SLUGS FROM API
      api_slugs = []
      related_videos['data'].each do |v|
        api_slugs << v['metadata']['slug']
      end
      if related_videos['data'].count < fe_count
        generic_videos['data'].each do |v|
          api_slugs << v['metadata']['slug']
        end
      end

      # STORE SLUGS FROM FE
      fe_slugs = []
      @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |v|
        fe_slugs << v.attribute('href').to_s.match(/[^\/]{2,}$/).to_s
      end

      # COMPARE API SLUGS TO FE SLUGS
      (api_slugs - fe_slugs).length.should < 3
      api_slugs.length.should > 9
      fe_slugs.length.should > 9

    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

    it "should highlight IGN Shows when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector span.item-container span[data-type='shows']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector span[class='item-container container-selected'] span").attribute('data-type').to_s.should == 'shows'
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display IGN Shows when clicked" do
      
      pending 'pending'

      # GET IGN SHOWS AND STORE VALUES
      api_titles = []
      api_slugs = []

      ["IGN Daily Fix","IGN Strategize","Whats New","IGN Fan Academy","Future of Gaming","IGN Weekly 'Wood","PlayStation Conversation","IGN Live","IGN Rewind Theater","Boss Breakdown","IGN Babeology","IGN Originals","Tech Tip of the Week"].each do |show|
        search_body = {
                      :rules=>[
                        {
                          :field=>"extra.videoSeries",
                          :condition=>"is",
                          :value=>show
                        }
                      ],
                      :matchRule=>"matchAll",
                      :prime=>false,
                      :networks=>"ign",
                      :regions=>["US"]
                    }.to_json
        search_url = "http://#{@data_config.options['baseurl']}/v3/videos/search?q=#{search_body}&fresh=true".gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
        shows_response = RestClient.get search_url
        shows = JSON.parse(shows_response.body)

        video_long_title = false

        begin
          video_long_title = shows['data'][0]['metadata']['longTitle']
          if video_long_title.nil?; throw Exception.new end
        rescue
          video_long_title = false
          video_title = shows['data'][0]['metadata']['title']
          begin
            object_name =  shows['data'][0]['objectRelations'][0]['objectName']+" - "
          rescue
            object_name = ""
          end
        end

        if video_long_title == false
          api_titles << (object_name+video_title).downcase.gsub(/\s{2,}/, ' ')
        else
          api_titles << video_long_title.downcase.gsub(/\s{2,}/, ' ')
        end
        api_slugs << shows['data'][0]['metadata']['slug']
      end

          ## COMPARE TITLES ##

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip.gsub(/\s{2,}/, ' ')
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 3
      api_titles.length.should > 9
      fe_titles.length.should > 9

          ## COMPARE LINK ##

      # STORE SLUGS FROM FE
      fe_slugs = []
      @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |v|
        fe_slugs << v.attribute('href').to_s.match(/[^\/]{2,}$/).to_s
      end

      # COMPARE API SLUGS TO FE SLUGS
      (api_slugs - fe_slugs).length.should < 3
      api_slugs.length.should > 9
      fe_slugs.length.should > 9

    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

    it "should highlight Reviews when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector span.item-container span[data-type='reviews']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector span[class='item-container container-selected'] span").attribute('data-type').to_s.should == 'reviews'
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Reviews when clicked" do
      # GET REVIEWS
      search_body = {
          :rules=>[
              {
                  :field=>"metadata.classification",
                  :condition=>"is",
                  :value=>"Review"
              }
          ],
          :matchRule=>"matchAll",
          :prime=>false,
          #:startIndex=>0,
          #:count=>20,
          :networks=>"ign",
          :regions=>["US"]
      }.to_json
      search_url = "http://#{@data_config.options['baseurl']}/v3/videos/search?q=#{search_body}".gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      reviews_response = RestClient.get search_url
      reviews = JSON.parse(reviews_response.body)
          ## COMPARE TITLES ##

      # STORE TITLES FROM API
      api_titles = get_api_titles(reviews)

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip.gsub(/\s{2,}/, ' ')
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 3
      api_titles.length.should > 9
      fe_titles.length.should > 9

         ## COMPARE LINK ##

      # STORE SLUGS FROM API
      api_slugs = []
      reviews['data'].each do |v|
        api_slugs << v['metadata']['slug']
      end

      # STORE SLUGS FROM FE
      fe_slugs = []
      @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |v|
        fe_slugs << v.attribute('href').to_s.match(/[^\/]{2,}$/).to_s
      end

      # COMPARE API SLUGS TO FE SLUGS
      (api_slugs - fe_slugs).length.should < 3
      api_slugs.length.should > 9
      fe_slugs.length.should > 9

    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

    it "should highlight Trailers when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector span.item-container span[data-type='trailers']").click
      sleep 1
       @selenium.find_element(:css => "div.video_playlist_selector span[class='item-container container-selected'] span").attribute('data-type').to_s.should == 'trailers'
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Trailers when clicked" do
      # GET TRAILERS
      search_body = {
          :rules=>[
              {
                  :field=>"metadata.classification",
                  :condition=>"is",
                  :value=>"Trailer"
              }
          ],
          :matchRule=>"matchAll",
          :prime=>false,
          #:startIndex=>0,
          #:count=>20,
          :networks=>"ign",
          :regions=>["US"]
      }.to_json
      search_url = "http://#{@data_config.options['baseurl']}/v3/videos/search?q=#{search_body}".gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      trailers_response = RestClient.get search_url
      trailers = JSON.parse(trailers_response.body)

          ## COMPARE TITLES ##

      # STORE TITLES FROM API
      api_titles = get_api_titles(trailers)

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip.gsub(/\s{2,}/, ' ')
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 3
      api_titles.length.should > 9
      fe_titles.length.should > 9

          ## COMPARE LINK ##

      # STORE SLUGS FROM API
      api_slugs = []
      trailers['data'].each do |t|
        api_slugs << t['metadata']['slug']
      end

      # STORE SLUGS FROM FE
      fe_slugs = []
      @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |v|
        fe_slugs << v.attribute('href').to_s.match(/[^\/]{2,}$/).to_s
      end

      # COMPARE API SLUGS TO FE SLUGS
      (api_slugs - fe_slugs).length.should < 3
      api_slugs.length.should > 9
      fe_slugs.length.should > 9
    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should highlight Must Watch videos when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector span.item-container span[data-type='taboola']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector span[class='item-container container-selected'] span").attribute('data-type').to_s.should == 'taboola'
    end

    it "should be populated with at least 10 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Must Watch videos when clicked" do
      @selenium.find_elements(:css => "ul#videos-list li a").count.should > 9
      @selenium.find_elements(:css => "ul#videos-list li a").each do |a|
        ign_video_url = /ign.com\/videos\/\d{4}\/\d{2}\/\d{2}\/./
        taboola_url = /api\.taboola/
        begin
          link = a.attribute('href').to_s
          (link.match(ign_video_url)||link.match(taboola_url)).should be_true
          a.text.delete('^a-zA-Z').length.should > 0
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          next
        end
      end
    end

    if locale == 'www'
      it "should only contain links that 200", :spam => true do
        @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end
  end

  context "Video Details (Below Fold)" do

    it "should display the video title once" do
      @selenium.find_elements(:css => "div#object-details div.page-object-title").count.should == 1
      @selenium.find_element(:css => "div#object-details div.page-object-title").displayed?.should be_true
    end

    it "should display the correct video title" do
      title = @selenium.find_element(:css => "div#object-details div.page-object-title").text.downcase.gsub(/ +/, ' ')
      title.chomp.strip.should == get_api_title(@video_data).gsub(/ +/, ' ')
    end

    it "should display the video date once" do
      @selenium.find_elements(:css => "div#object-details span.page-object-date").count.should == 1
      @selenium.find_element(:css => "div#object-details span.page-object-date").displayed?.should be_true
    end

    it "should display the correct video date" do
      date = @selenium.find_element(:css => "div#object-details span.page-object-date").text.downcase.chomp.strip
      Time.parse(date).should == Time.parse(@video_data['metadata']['url'].match(/\d{4}\/\d{2}\/\d{2}/).to_s)
    end

    it "should display the video description once" do
      @selenium.find_elements(:css => "div#object-details span.page-object-description").count.should == 1
      @selenium.find_element(:css => "div#object-details span.page-object-description").displayed?.should be_true
    end

    it "should display the correct description" do
=begin
      begin
        description = @video_data['promo']['summary'].strip
        if description.to_s.delete('^a-zA-Z0-9').length < 1; throw Exception.new end
      rescue
        description = @video_data['metadata']['description'].strip
      end
=end
      description = @video_data['metadata']['description'].strip
      desc = @selenium.find_element(:css => "div#object-details span.page-object-description").text.strip.chomp.gsub(/\s+/,' ')
      desc.should == description.strip.chomp.gsub(/\s+/,' ')

    end
  end

  context "Related Videos Widget (Right Rail)" do
    check_related_videos
  end

  context "Disqus Widget" do
    check_disqus
  end

  context "Add This Widget" do
    check_add_this
  end

  context "Object Details Widget" do
    check_object_details
  end

  context "Global Footer Widget" do
    check_global_footer
  end

end end end
