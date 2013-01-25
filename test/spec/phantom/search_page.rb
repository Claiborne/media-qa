require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'open_page'
require 'json'
require 'open_page'; include OpenPage
require 'widget-plus/global_header_nav.rb'; include GlobalHeaderNav
require 'widget-plus/global_footer.rb'; include GlobalFooter

%w(www uk au).each do |locale|
['halo 4', 'game of thrones'].each do |query|
describe "Search Page -- #{locale.upcase}", :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/phantom.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
    @browser_config = BrowserConfig.new
    @page = "http://#{@config.options['baseurl']}/search?q=#{query}&special=noads".gsub('//www',"//#{locale}")

    puts @browser_config.options['browser'].to_s
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    case locale
      when 'uk'
        @selenium.get "http://uk.ign.com/?setccpref=UK"
      when 'au'
        @selenium.get "http://au.ign.com/?setccpref=AU"
      else
    end

    # Search using global header
    @selenium.get "http://#{@config.options['baseurl']}"+"?special=noads"
    search_box = @selenium.find_element :css => 'input#ignHeader-search'
    search_box.send_keys(query)
    search_box.submit

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should open the search page in #{ENV['env']}" do
    @selenium.get @page
    sleep 3
    @selenium.current_url.gsub('%20',' ').should == @page
  end

  context "Global Header and Nav Widget" do
    check_global_header_nav
  end

  context "Search Header" do

    it "should be displayed" do
      @selenium.find_element :css => "div[class='search-header ']"
    end

    it "should display the input box" do
      @selenium.find_element(:css => "div[class='search-header '] input#query-input").displayed?.should be_true
    end

    it "should display the query in the input box" do
      @selenium.find_element(:css => "div[class='search-header '] input#query-input").attribute('value').should == query
    end

  end

  context "Search Menu Bar (Static)" do

    it "should be displayed" do
      @selenium.find_element(:css => "div.search-menu-bar div.menu-bar").displayed?.should be_true
    end

    it "should display the correct text" do
      expected_nav = %w(everything games tv/movies videos articles wikis)
      nav = []

      @selenium.find_elements(:css => "div.search-menu-bar div.menu-bar div.menu-item").each do |li|
        nav << li.text.downcase
      end

      nav.should == expected_nav
    end

  end

  context "Search Results" do

    it "should be displayed" do
      @selenium.find_element(:css => 'div#search-list').displayed?.should be_true
    end

    it "should return 10 results" do
      @selenium.find_elements(:css => 'div#search-list div.search-item').count.should == 10
    end

    it "should return and display 10 titles" do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').count.should == 10
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').each do |title|
        title.displayed?.should be_true
        title.text.delete('^a-zA-Z').length.should > 0
      end
    end

    it "should link to an IGN page when the title is clicked" do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').count.should == 10
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |title|
        title.attribute('href').to_s.match(/ign\.com\/[a-z]/).should be_true
      end
    end

    it "should open a page when the title is clicked", :spam => true do
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |title|
        rest_client_not_301_home_open title.attribute('href').to_s
      end
    end

    if query == 'halo 4'

      it "should return Halo 4 game in the top 3" do
        halo_title = false; halo_url = false
        @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').first(3).each do |title|
          halo_title = true if title.text.gsub(/\s+/, '').downcase == query.gsub(/\s+/, '')
        end
        # Grab top 3 URLs
        @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').first(3).each do |a|
          halo_url = true if a.attribute('href').to_s.match(/http:\/\/[a-z]{1,}.ign.com\/games\/halo-4\/xbox-360-110563/)
        end

        halo_title.should be_true
        halo_url.should be_true
      end

    elsif query == 'game of thrones'

      it "should return Game Of Thrones show in the top 3" do
        thrones_title = false; thrones_url = false
        @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').first(3).each do |title|
          thrones_title = true if title.text.gsub(/\s+/, '').downcase == query.gsub(/\s+/, '')
        end
        # Grab top 3 URLs
        @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').first(3).each do |a|
          thrones_url = true if a.attribute('href').to_s.match(/http:\/\/[a-z]{1,}.ign.com\/tv\/game-of-thrones/)
        end

        thrones_title.should be_true
        thrones_url.should be_true
      end

    end

    context "Show 10 More" do

      it "should display 10 more results when clicked" do
        load_more = @selenium.find_element(:css => 'div#search-list div#load-more-button')
        load_more.click
        @wait.until { @selenium.find_elements(:css => 'div#search-list div.search-item').count == 20 }
        @wait.until { @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title').count == 20 }
      end

    end

  end

  context "Search Menu Bar (Functional)" do

    it "should return only game results when filtered by games" do
      current_titles = @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title')
      @selenium.find_element(:css => "div.search-menu-bar div[data-objecttype='game']").click
      @wait.until {current_titles != @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title') }
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |a|
        a.attribute('href').to_s.match(/\.com\/games\/./).should be_true
      end
    end

    it "should return only tv show and movie results when filtered by tv/movies" do
      current_titles = @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title')
      @selenium.find_element(:css => "div.search-menu-bar div[data-objecttype='movie,show']").click
      @wait.until {current_titles != @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title') }
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |a|
        movies = a.attribute('href').to_s.match(/\.com\/movies\/./)
        tv = a.attribute('href').to_s.match(/\.com\/tv\/./)
        (movies||tv).should be_true
      end
    end

    it "should return only video results when filtered by videos" do
      current_titles = @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title')
      @selenium.find_element(:css => "div.search-menu-bar div[data-filter='videos']").click
      @wait.until {current_titles != @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title') }
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |a|
        a.attribute('href').to_s.match(/\.com\/videos\/./).should be_true
      end
    end

    it "should return only article results when filtered by articles" do
      current_titles = @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title')
      @selenium.find_element(:css => "div.search-menu-bar div[data-filter='articles']").click
      @wait.until {current_titles != @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title') }
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |a|
        articles = a.attribute('href').to_s.match(/\.com\/articles\/./)
        blogs = a.attribute('href').to_s.match(/\.com\/blogs\/./)
        (articles||blogs).should be_true
      end
    end

    it "should return only wiki results when filtered by wikis" do
      current_titles = @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title')
      @selenium.find_element(:css => "div.search-menu-bar div[data-filter='wiki']").click
      @wait.until {current_titles != @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title') }
      @selenium.find_elements(:css => 'div#search-list div.search-item div.search-item-title a').each do |a|
        a.attribute('href').to_s.match(/\.com\/wikis\/./).should be_true
      end
    end

  end

  context "Global Footer Widget" do
    check_global_footer
  end

end end end