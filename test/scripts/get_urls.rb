require 'rest_client'
require 'json'

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

230.times do
  puts "/"
end


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
