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

number_of_requests = 200
sleep_num = 0.3
puts "NUMBER OF REQUESTS: #{number_of_requests}"
puts "SLEEPING #{sleep_num} SECONDS BETWEEN EACH"

%w(www m).each do |site|
%w(US-www-1 UK-uk-1 AU-au-1).each do |locale|

  if site == 'www'; then platform = 'Desktop'; else platform = 'Mobile'; end

  puts "------- #{platform} #{locale.match(/../)}  ------- ".green

  cache_result = []
  served_by = []
  hits = []
  missed = []
  v_01 = []
  v_02 = []
  (1..number_of_requests).each do
    sleep sleep_num
    url = "http://#{site}.ign.com"
    get = RestClient.get(url, :cookies=>{"i18n-ccpref"=>"13-#{locale}"})
    cache_result << get.headers[:x_cache_result].to_s
    served_by <<  get.headers[:x_served_by].match(/\d\d/).to_s
  end

  cache_result.each do |c|
    hits << c if c == 'HIT'
    missed << c if c == 'MISS'
  end

  served_by.each do |s|
    v_01 << s if s == '01'
    v_02 << s if s == '02'
  end

  if missed
    hit_rate = "#{(hits.length.to_f/cache_result.length.to_f)*100}%"
  else
    hit_rate = "100%"
  end

  puts "HIT RATE #{hit_rate}".red
  puts "01: #{(v_01.length.to_f/served_by.length.to_f)*100}%".yellow
  puts "02: #{(v_02.length.to_f/served_by.length.to_f)*100}%".yellow

end
end