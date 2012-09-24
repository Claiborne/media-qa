require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'json'
require 'time'

include OpenPage
include FeChecker

%w(game-of-thrones).each do |url_slug|
%w(www uk au).each do |domain_locale|

describe "Oyster Game Object Pages - #{domain_locale}.ign.com/tv/#{url_slug}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @base_url = @config.options['baseurl'].gsub(/www./,"#{domain_locale}.")
    @url = "http://#{@base_url}/tv/#{url_slug}"
    @cookie =  get_international_cookie(domain_locale)
    @doc = nokogiri_not_301_open(@url,@cookie)
    @legacy_id = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/shows/slug/game-of-thrones").body)['metadata']['legacyId'].to_s
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
    @data = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/shows/legacyId/#@legacy_id").body)
    @us_data = (JSON.parse RestClient.get("http://apis.lan.ign.com/object/v3/shows/legacyId/#@legacy_id?").body)
  end # end before all

  it "should return 200" do
  end

  it "should return the #{domain_locale} page" do
    get_local(@base_url,@cookie).should == domain_locale
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

    it "should display the same air status the object API returns" do
      @doc.css('div.contentDetails div:nth-child(2) strong').text.downcase.should == @data['metadata']['airDate']['status']
    end

    it "should display the same air date the object API returns" do
      Time.parse(@doc.css('div.contentDetails div:nth-child(4) strong').text).to_s.match(/^.{10}/).to_s.should == @data['metadata']['airDate']['show']
    end

    it "should include the Facebook Like button" do
      @doc.at_css('div.fb-like iframe').attribute('src').to_s.match(/facebook.com/).should be_true
    end

  end

  context "Object Navigation" do

    it "should have at least four links" do
      @doc.css('ul.contentNav li a').count.should > 3
    end

    it "should display text for each link" do
      check_display_text_for_each('ul.contentNav li a')
    end

    %w(tv videos images articles).each do |link|
      it "should link to #{link}" do
        @doc.at_css("ul.contentNav li a[href*='"+link.to_s+"']").should be_true
      end
    end

    it "should link to /tv/#{url_slug}" do
      @doc.at_css("ul.contentNav li a[href*='tv/#{url_slug}']").should be_true
    end

    it "should not contain any broken links" do
      check_links_not_301_home('ul.contentNav')
    end

  end

end end end

