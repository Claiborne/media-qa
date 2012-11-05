require 'rspec'
require 'selenium-webdriver'
require 'configuration'
require 'rest-client'
require 'open_page'
require 'json'
require 'Time'
require 'open_page'

include OpenPage

class VideoPlayerPageHelper
  def self.get_latest_videos

    count = 5

    DataConfiguration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    data_config = DataConfiguration.new

    list_of_date_and_slugs = []
    latest_vids_response = RestClient.get "http://#{data_config.options['baseurl']}/v3/videos?count=#{count}&sortBy=metadata.publishDate&sortOrder=desc&metadata.networks=ign"
    latest_vids = JSON.parse(latest_vids_response.body)
    latest_vids['data'].each do |v|
      list_of_date_and_slugs << v['metadata']['url'].match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/[^?]{1,}/).to_s
    end
    list_of_date_and_slugs
  end

  def self.get_api_titles(d)
    api_titles = []
    d['data'].each do |v|
      video_long_title = false
      begin
        video_long_title = v['metadata']['longTitle']
        if video_long_title.nil?; throw Exception.new end
      rescue
        video_long_title = false
        video_title = v['metadata']['title'].strip
        begin
          object_name =  v['objectRelations'][0]['objectName'].strip+" - "
        rescue
          object_name = ""
        end
      end

      if video_long_title == false
        api_titles << (object_name+video_title).downcase
      else
        api_titles << video_long_title.downcase.strip
      end
    end
    api_titles
  end

  def self.get_api_title(d)
    api_title = ''
    video_long_title = false
    begin
      video_long_title = d['metadata']['longTitle']
      if video_long_title.nil?; throw Exception.new end
    rescue
      video_long_title = false
      video_title = d['metadata']['title'].strip
      begin
        object_name =  d['objectRelations'][0]['objectName'].strip+" - "
      rescue
        object_name = ""
      end
    end

    if video_long_title == false
      api_title << (object_name+video_title).downcase
    else
      api_title << video_long_title.downcase.strip
    end
    api_title
  end

end

######################################################################

VideoPlayerPageHelper.get_latest_videos.each do |video_page|
describe "Video Player Page -- #{video_page}", :selenium => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/phantom.yml"
    @config = Configuration.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new
    DataConfiguration.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @data_config = DataConfiguration.new

    @page = "http://#{@config.options['baseurl']}#{video_page}"
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 60)

    data_response = RestClient.get "http://#{@data_config.options['baseurl']}/v3/videos/slug/#{video_page.match(/[^\/]{2,}$/)}"

    @video_data = JSON.parse(data_response.body)
  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open #{video_page} on #{ENV['env']}" do
    @selenium.get @page
    sleep 5
    @selenium.current_url.should == @page
  end

  it "should display the global header and nav once" do
    @selenium.find_elements(:css => "div#ignHeader div#ignHeader-userBar").count.should == 1
    @selenium.find_element(:css => "div#ignHeader div#ignHeader-userBar").displayed?.should be_true

    @selenium.find_elements(:css => "div#ignHeader div#ignHeader-navigation").count.should == 1
    @selenium.find_element(:css => "div#ignHeader div#ignHeader-navigation").displayed?.should be_true
  end

  it "should display the IGN video player once" do
    @selenium.find_elements(:css => "object#IGNPlayer").count.should == 1
    @selenium.find_element(:css => "object#IGNPlayer").displayed?.should be_true
  end

  it "should display the correct video title" do
    all = @selenium.find_element(:css => "div.video_details div.video_title")
    duration = @selenium.find_element(:css => "div.video_details div.video_title span.video-duration")
    date = @selenium.find_element(:css => "div.video_details div.video_title div.sub-details")

    all.displayed?.should be_true

    all.text.gsub(duration.text,"").gsub(date.text,"").chomp.rstrip.downcase.should == VideoPlayerPageHelper.get_api_title(@video_data)
  end

  it "should display the duration" do
    duration = @selenium.find_element(:css => "div.video_details div.video_title span.video-duration")
    duration.displayed?.should be_true
    duration.text.match(/[0-9]{1,2}:[0-9]{2}/).should be_true
  end

  it "should display the date" do
    date = @selenium.find_element(:css => "div.video_details div.video_title div.sub-details")
    date.displayed?.should be_true
    Time.parse(date.text).should == Time.parse(@video_data['metadata']['publishDate'].match(/\d{4}-\d{2}-\d{2}/).to_s)
  end

  it "should display the medrec div once" do
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
      @selenium.find_element(:css => "div#video_playlist ul").displayed?.should be_true
    end

    it "should correctly display the navigation text" do
      nav_text = ['RELATED','IGN SHOWS', 'REVIEWS', 'TRAILERS']
      items = @selenium.find_elements(:css => "div.video_playlist_selector a.video_playlist_button div.item")
      items.count.should.should == 4
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

    it "should highlight Related videos in the nav by default" do
      selected = @selenium.find_element(:css => "div.video_playlist_selector div.item-container")
      selected.attribute('class').to_s.match(/container-selected/).should be_true
      selected.text.should == 'RELATED'
    end

    it "should be populated with 20 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Related videos by default" do

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
        api_titles = VideoPlayerPageHelper.get_api_titles(related_videos)+VideoPlayerPageHelper.get_api_titles(generic_videos)
      else
        api_titles = VideoPlayerPageHelper.get_api_titles(related_videos)
      end

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 2
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
      api_slugs.should == fe_slugs

    end

    it "should highlight IGN Shows when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector div.item-container div[data-type='shows']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector a.video_playlist_button:nth-child(2) div.item-container").attribute('class').to_s.match(/container-selected/).should be_true
    end

    it "should be populated with 20 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display IGN Shows when clicked" do

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
                      #:startIndex=>0,
                      #:count=>20,
                      :networks=>"ign",
                      :regions=>["US"]
                    }.to_json
        search_url = "http://#{@data_config.options['baseurl']}/v3/videos/search?q=#{search_body}".gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
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
          api_titles << (object_name+video_title).downcase
        else
          api_titles << video_long_title.downcase
        end
        api_slugs << shows['data'][0]['metadata']['slug']

      end

          ## COMPARE TITLES ##

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 2
      api_titles.length.should > 9
      fe_titles.length.should > 9

          ## COMPARE LINK ##

      # STORE SLUGS FROM FE
      fe_slugs = []
      @selenium.find_elements(:css => "div#video_playlist ul#videos-list li a").each do |v|
        fe_slugs << v.attribute('href').to_s.match(/[^\/]{2,}$/).to_s
      end

      # COMPARE API SLUGS TO FE SLUGS
      api_slugs.should == fe_slugs

    end


    it "should highlight Reviews when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector div.item-container div[data-type='reviews']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector a.video_playlist_button:nth-child(3) div.item-container").attribute('class').to_s.match(/container-selected/).should be_true
    end

    it "should be populated with 20 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Reviews when clicked" do
      # GET REVIEWS
      search_body = {
          :rules=>[
              {
                  :field=>"metadata.classification",
                  :condition=>"is",
                  :value=>"review"
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
      api_titles = VideoPlayerPageHelper.get_api_titles(reviews)

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 2
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
      api_slugs.should == fe_slugs

    end

    it "should highlight Trailers when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector div.item-container div[data-type='trailers']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector a.video_playlist_button:nth-child(4) div.item-container").attribute('class').to_s.match(/container-selected/).should be_true
    end

    it "should be populated with 20 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
    end

    it "should display Trailers when clicked" do
      # GET TRAILERS
      search_body = {
          :rules=>[
              {
                  :field=>"metadata.classification",
                  :condition=>"is",
                  :value=>"trailer"
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
      api_titles = VideoPlayerPageHelper.get_api_titles(trailers)

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 2
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
      api_slugs.should == fe_slugs
    end

    it "should highlight Related videos when clicked" do
      @selenium.find_element(:css => "div.video_playlist_selector div.item-container div[data-type='related']").click
      sleep 1
      @selenium.find_element(:css => "div.video_playlist_selector a.video_playlist_button div.item-container").attribute('class').to_s.match(/container-selected/).should be_true
    end

    it "should be populated with 20 list item links" do
      @selenium.find_elements(:css => "ul#videos-list li").count.should > 9
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
        api_titles = VideoPlayerPageHelper.get_api_titles(related_videos)+VideoPlayerPageHelper.get_api_titles(generic_videos)
      else
        api_titles = VideoPlayerPageHelper.get_api_titles(related_videos)
      end

      # STORE TITLES FROM FE
      fe_titles = []
      @selenium.find_elements(:css => "ul#videos-list li").each do |t|
        fe_titles << t.text.downcase.strip
      end

      # COMPARE API TITLES TO FE TITLES
      (api_titles - fe_titles).length.should < 2
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
      api_slugs.should == fe_slugs

    end

  end

  context "Video Details (Below Fold)" do

    it "should display the video title once" do
      @selenium.find_elements(:css => "div#object-details div.page-object-title").count.should == 1
      @selenium.find_element(:css => "div#object-details div.page-object-title").displayed?.should be_true
    end

    it "should display the correct video title" do
      title = @selenium.find_element(:css => "div#object-details div.page-object-title").text.downcase
      title.chomp.strip.should == VideoPlayerPageHelper.get_api_title(@video_data)
    end

    it "should display the video date once" do
      @selenium.find_elements(:css => "div#object-details span.page-object-date").count.should == 1
      @selenium.find_element(:css => "div#object-details span.page-object-date").displayed?.should be_true
    end

    it "should display the correct video date" do
      date = @selenium.find_element(:css => "div#object-details span.page-object-date").text.downcase.chomp.strip
      Time.parse(date).should == Time.parse(@video_data['metadata']['publishDate'].match(/\d{4}-\d{2}-\d{2}/).to_s)
    end

    it "should display the video description once" do
      @selenium.find_elements(:css => "div#object-details span.page-object-description").count.should == 1
      @selenium.find_element(:css => "div#object-details span.page-object-description").displayed?.should be_true
    end

    it "should display the correct description" do

      begin
        description = @video_data['promo']['summary']
        if description.to_s.delete('^a-zA-Z0-9').length < 1; throw Exception.new end
      rescue
        description = @video_data['metadata']['description']
      end

      desc = @selenium.find_element(:css => "div#object-details span.page-object-description").text.chomp.strip
      desc.should == description

    end

  end

  context "Disqus Widget" do

    it "should display once" do
      @selenium.find_elements(:css => "div#disqus_thread").count.should == 1
      @selenium.find_elements(:css => "div#disqus_thread iframe").count.should == 4
      @selenium.find_element(:css => "div#disqus_thread iframe").displayed?.should be_true
    end

  end

  context "Global Footer" do

    it "should display once" do
      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-topRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-topRow").displayed?.should be_true

      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-bottomRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-bottomRow").displayed?.should be_true
    end

  end


end end
