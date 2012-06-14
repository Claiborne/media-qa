require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'


def game_review_articles
  {"matchRule"=>"matchAll",
  "count"=>10,
  "startIndex"=>0,
  "networks"=>"ign",
  "states"=>"published",
  "rules"=>[
    {"field"=>"tags",
    "rules"=>[
      {
      "field"=>"tags.slug",
      "condition"=>"is",
      "value"=>"games"},
      {
      "field"=>"tags.tagType",
      "condition"=>"is",
      "value"=>"objectType"}]
    },
    {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"article"},
    {"field"=>"tags",
    "condition"=>"containsAll",
    "value"=>"review"}],
  "sortBy"=>"metadata.publishDate",
  "sortOrder"=>"desc"
  }.to_json
end


url = "http://apis.lan.ign.com/article/v3/articles/search?q="+game_review_articles.to_s
url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
response = RestClient.get url
data = JSON.parse(response.body)
data['data'].each do |article|
  
  objectRelations = []
  objectRelations = article["legacyData"]["objectRelations"]
  catch (:error_404) do
  objectRelations.each do |object|
    begin
      object_response = RestClient.get "http://content-api.ign.com/v1/games/#{object}.json"
    rescue
      puts "ERROR ON: http://apis.lan.ign.com/article/v3/articles/#{article['articleId']}"
      throw :error_404
    end
    game_data = JSON.parse(object_response.body)
    if game_data['game']['editorialRating'].to_s.match(/./)
      puts "PASS: http://content-api.ign.com/v1/games/#{object}.json"
    else
      puts "-------->"
      puts "--------> FAILURE: http://content-api.ign.com/v1/games/#{object}.json"
      puts "--------> Republish the following article: http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
      puts "-------->"
    end
  end #end objectRelations iteration
  end #end catch
    
end #end article iteration



