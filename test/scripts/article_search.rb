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

def cheats
{"matchRule"=>"matchAll",
 "sortBy"=>"metadata.publishDate",
 "sortOrder"=>"desc",
 "count"=>70,
 "startIndex"=>0,
 "networks"=>"ign",
 "states"=>"published",
 "rules"=>[
   {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"cheat"},
   ]
}.to_json
end

def xboxmobile
{"matchRule"=>"matchAll",
 "count"=>60,
 "startIndex"=>0,
 "networks"=>"ign",
 "states"=>"published",
 "rules"=>[
   {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"article"},
  {"field"=>"categoryLocales",
   "condition"=>"contains",
   "value"=>"us"},
  {"field"=>"tags.slug",
   "condition"=>"contains",
   "value"=>"blogroll"}
  # "value"=>"news,feature,review,preview"}#,
 # {"field"=>"categories.slug",
  # "condition"=>"contains",
   #{}"value"=>"xbox-360"}
  ]
}.to_json
end

def legacyarticle
  {"matchRule"=>"matchAll",
   "rules"=>[
     {"field"=>"metadata.articleType",
       "condition"=>"is",
       "value"=>"article"},
     {"field"=>"legacyData.legacyArticles.legacyId",
      "condition"=>"is",
      "value"=>"1223071"}
    ]
  }.to_json
end

def wiiu
{"matchRule"=>"matchAll",
 "count"=>100,
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
    "value"=>"uk"}   ###
    ],
  "sortBy"=>"metadata.publishDate",
  "sortOrder"=>"desc"
}.to_json
     
end

def tech
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
     "value"=>"tech"},
   {"field"=>"categoryLocales",
     "condition"=>"contains",
     "value"=>"us"}
     ],
 "sortBy"=>"metadata.publishDate",
 "sortOrder"=>"desc"
 }.to_json
end

def skyrim_cheats
{"matchRule"=>"matchAll",
 "count"=>100,
 "rules"=>[
   {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"cheat"},
   {"field"=>"legacyData.objectRelations",
     "condition"=>"is",
     "value"=>"14267318"}
  ]
}.to_json
end

def promos
{"matchRule"=>"matchAll",
 "count"=>60,
 "startIndex"=>0,
 "networks"=>"ign",
 "rules"=> [
   {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"article"},
  {"field"=>"tags.slug",
   "condition"=>"contains",
   "value"=>"promotion"}
  ]
}.to_json
end

=begin
tech subpages
{"field"=>"tags",
"condition"=>"containsAll",
"value"=>"tech,wii-u"}
=end

def prdfail
  {"matchRule"=>"matchAll","count"=>10,"startIndex"=>0,"networks"=>"ign","states"=>"published","rules"=>[{"field"=>"metadata.articleType","condition"=>"is","value"=>"article"},{"field"=>"categories.slug","condition"=>"contains","value"=>"wii"},{"field"=>"categoryLocales","condition"=>"contains","value"=>"us"}],"sortBy"=>"metadata.publishDate","sortOrder"=>"desc"}.to_json
end

v3 = []; v2 =[]

@url = "http://apis.lan.ign.com/article/v3/articles/search"
@response = RestClient.post @url, prdfail, :content_type => "application/json"
@data = JSON.parse(@response.body)
File.open('/Users/wclaiborne/Desktop/test.json', 'w') {|f| f.write(@response.to_s) }