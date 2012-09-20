require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'json'

include OpenPage
include FeChecker

%w(game-of-thrones).each do |url_slug|
%w(www uk au).each do |domain_locale|

describe "Oyster Game Object Pages - #{domain_locale}.ign.com/tv/#{url_slug}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
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
  end

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

    it "should display the same platform the object API returns" do
      @doc.css('div.contentPlatformsText').text.should == @data['hardware']['platform']['metadata']['name']
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
end end end

