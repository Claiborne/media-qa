require 'rest_client'
require 'json'
require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'open_page'

wp_ids = []
obj_ids = []

file = File.new("/Users/wclaiborne/Desktop/wp_remigrate.txt", "r")
while (line = file.gets)
  wp_ids << line
end
file.close

wp_ids.each do |i|
  res = RestClient.get "http://apis.lan.ign.com/article/v3/articles/wordpressId/#{i}"
  data = JSON.parse(res.body)
  data['legacyData']['objectRelations'].each do |o|
    obj_ids << o.to_s
  end
end

puts obj_ids