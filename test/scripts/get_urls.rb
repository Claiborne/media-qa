require 'rest_client'
require 'json'

## PHANTOM ##

# Video Player Page

%w(0 200).each do |start_index|
  url = "http://apis.lan.ign.com/video/v3/videos?count=200&startIndex=#{start_index}&metadata.networks=ign"
  response = RestClient.get url
  data = JSON.parse(response.body)

  data['data'].each do |d|
    year = d['metadata']['publishDate'].match(/^\d\d\d\d/).to_s
    month = d['metadata']['publishDate'].match(/-\d\d-/).to_s.match(/\d\d/).to_s
    day = d['metadata']['publishDate'].match(/\d\dT/).to_s.match(/\d\d/).to_s
    slug = d['metadata']['slug']
    puts "/videos/#{year}/#{month}/#{day}/#{slug}"
  end
end

# Search Results Page
queries = %w(ps4 last%20of%20us last%20of%20us&page=0&count=10&type=object&objectType=game&filter=games& halo%205 xbox%20one xbox%20one&page=0&count=10&type=object&objectType=game&filter=games& assassins%20creed%20iv arkham%20origins battlefield%204 bayonetta%202 civ%205 lords%20of%20shadow call%20of%20duty call%20of%20duty&page=0&count=10&type=object&objectType=game&filter=games& call%20of%20duty%20ghosts dark%20souls%20ii destiny diablo final%20fantasy forza%205 flower infamous killzone knack lego madden%2025 nhl%2014 rain rayman%20legends)

3.times do
  queries.each do |q|
    puts "/search?q=#{q}"
  end
end

## OYSTER ##

# Homepage

230.times do
  puts "/"
end

# Articles

url = 'http://apis.lan.ign.com/article/v3/articles/type/article?count=200'
response = RestClient.get url
data = JSON.parse(response.body)

data['data'].each do |d|
  year = d['metadata']['publishDate'].match(/^\d\d\d\d/).to_s
  month = d['metadata']['publishDate'].match(/-\d\d-/).to_s.match(/\d\d/).to_s
  day = d['metadata']['publishDate'].match(/\d\dT/).to_s.match(/\d\d/).to_s
  slug = d['metadata']['slug']
  puts "/articles/#{year}/#{month}/#{day}/#{slug}"
end

# This JSON is used for objects

search =  {
          "rules"=>[
          {
          "field"=>"legacyData.guideUrl",
          "condition"=>"exists",
          "value"=>""
          }
          ],
          "matchRule"=>"matchAll",
          "startIndex"=>0,
          "count"=>200,
          "states"=>["published"],
          "regions"=>["US"]
          }.to_json

# Wiki pages

url = "http://apis.lan.ign.com/object/v3/releases/search?q="+search.to_s
url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
response = RestClient.get url
data = JSON.parse(response.body)
ary = []
data['data'].each do |d|
  ary << d['legacyData']['guideUrl'].match(/\/wikis.{1,}$/).to_s
end
ary = ary.uniq!
ary.each do |a|
  puts a
end
puts ary.count