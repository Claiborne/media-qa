require 'rspec'
require 'nokogiri'
require 'rest_client'

describe "Mobile Blogroll" do

  it 'should match home' do
    mobile_list = []
    desktop_list = []

    mobile = Nokogiri::HTML(RestClient.get("http://wclaiborne.dev.m.ign.com?filter=latest"))
    desktop = Nokogiri::HTML(RestClient.get("http://www.ign.com"))

    desktop.css('div.blogrollContainer div.listElmnt h3 a').each do |a|
      desktop_list << a.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s.match(/\A[^?]{1,}/).to_s
    end

    i = 0
    mobile.css('ul#list_articles li a').each do |a|
      if i < 4; next if a.attribute('href').to_s.match('app-store-update') end
      mobile_list << a.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s.match(/\A[^?]{1,}/).to_s
      i = i + 1
      break if i == desktop_list.length
    end

    mobile_list.length.should == desktop_list.length
    mobile_list.should == desktop_list

  end

  %w(xbox-360 ps3 wii pc 3ds ps-vita mobile tv movies comics tech).each do |m|
  it "should match #{m}" do
    case m
      when 'wii'; d = 'wii-u'
      when '3ds'; d = 'ds'
      when 'mobile'; d = 'wireless'
      else; d = m
    end

    mobile_list = []
    desktop_list = []

    mobile = Nokogiri::HTML(RestClient.get("http://wclaiborne.dev.m.ign.com/?category=#{m}"))
    desktop = Nokogiri::HTML(RestClient.get("http://www.ign.com/#{d}"))

    desktop.css('div.blogrollContainer div.listElmnt h3 a').each do |a|
      desktop_list << a.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s.match(/\A[^?]{1,}/).to_s
    end

    i = 0
    mobile.css('ul#list_articles li a').each do |a|
      if i < 5; next if a.attribute('href').to_s.match('app-store-update') end
      mobile_list << a.attribute('href').to_s.match(/[^\/]{1,}\z/).to_s.match(/\A[^?]{1,}/).to_s
      i = i + 1
      break if i == desktop_list.length
    end

    mobile_list.length.should == desktop_list.length
    mobile_list.should == desktop_list

  end
  end

end

