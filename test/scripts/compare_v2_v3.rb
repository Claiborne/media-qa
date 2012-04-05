require 'rest_client'
require 'json'

def blogs
{"matchRule"=>"matchAll",
 "sortBy"=>"metadata.publishDate",
 "sortOrder"=>"desc",
 "count"=>20,
 "startIndex"=>0,
 "networks"=>"ign",
 "states"=>"published",
 "rules"=>[
   {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"post"},
   {"field"=>"system.spam",
    "condition"=>"isNot",
    "value"=>1}
   ]
}.to_json
end

def wiiu
{"matchRule"=>"matchAll",
 "count"=>10,
 "startIndex"=>0,
 "networks"=>"ign",
 "states"=>"published",
 "rules"=>[
   {"field"=>"metadata.articleType",
     "condition"=>"is",
     "value"=>"article"},
   {"field"=>"categories.slug",
    "condition"=>"contains",
    "value"=>"wii"},
   {"field"=>"categoryLocales",
    "condition"=>"contains",
    "value"=>"us"}
    ],
  "sortBy"=>"metadata.publishDate",
  "sortOrder"=>"desc"
}.to_json
     
end

def tech
{"matchRule"=>"matchAll",
 "count"=>60,
 "startIndex"=>0,
 "networks"=>"ign",
 "states"=>"published",
 "rules"=>[
   {"field"=>"metadata.articleType",
     "condition"=>"is",
     "value"=>"article"},
   {"field"=>"categories.slug",
     "condition"=>"contains",
     "value"=>"tech"},
   {"field"=>"categoryLocales",
     "condition"=>"contains",
     "value"=>"us"}
     ],
 "sortBy"=>"metadata.publishDate",
 "sortOrder"=>"desc"}.to_json
end

v3 = []; v2 =[]

@url = "http://apis.lan.ign.com/article/v3/articles/search"
@response = RestClient.post @url, tech, :content_type => "application/json"
@data = JSON.parse(@response.body)

@data['data'].each do |article|
  v3 << article['articleId']
end

@url_v2 = "http://api.ign.com/v2/articles.json?post_type=article&categories=tech&per_page=60&category_locales=us"
@response_v2 = RestClient.get @url_v2
@data_v2 = JSON.parse(@response_v2.body)

@data_v2.each do |article|
  v2 << article['id']
end

if v2 == v3
  puts "PASS"
else
  puts "FAIL. v2 - v3 comparison:"
  60.times do |x|
    print v2[x].to_s; print " "; print v3[x].to_s+"\n"
  end
end
  
#File.open('/Users/wclaiborne/Desktop/test.json', 'w') {|f| f.write(@response.to_s) }
