require 'rspec'
require 'pathconfig'
require 'nokogiri'
require 'rest_client'
require 'json'
require 'open_page'
require 'fe_checker'
require 'colorize'

include FeChecker
include OpenPage



%w(www m).each do |site|
%w(US-www-1 UK-uk-1 AU-au-1).each do |locale|
describe "Varnish for Oyster With (#{locale}) Cookie" do
  before(:all) do
    @cache_result = []
    @served_by = []
    (1..4).each do
      @url = "http://#{site}.ign.com"
      @get = RestClient.get(@url, :cookies=>{"i18n-ccpref"=>"13-#{locale}"})
      @cache_result << @get.headers[:x_cache_result].to_s
      @served_by << @get.headers[:x_served_by].match(/\d\d/).to_s
    end
  end

  it "Cache HIT Rate" do
    #@cache_result.length.should > 3
    #hits = @cache_result.delete('MISS')
    puts @cache_result
    #if hits
    #puts ""
    #puts hits
    #puts ""
    #puts "#{hits.length.to_f / @cache_result.length.to_f}"
    #else
      #puts "100%"
    #end
  end

end
end
end