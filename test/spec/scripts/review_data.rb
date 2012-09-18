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
    ]
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

def game_preview_articles
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
    ]
    },
    {"field"=>"metadata.articleType",
    "condition"=>"is",
    "value"=>"article"},
    {"field"=>"tags",
    "condition"=>"containsAll",
    "value"=>"preview"}],
  "sortBy"=>"metadata.publishDate",
  "sortOrder"=>"desc"
  }.to_json
end

puts ""
puts "--------------------- GAME REVIEWS ---------------------"
puts ""

url = "http://apis.lan.ign.com/article/v3/articles/search?q="+game_review_articles.to_s
url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
response = RestClient.get url
data = JSON.parse(response.body)
data['data'].each do |article|

  
  objectRelations = []
  objectRelations = article["legacyData"]["objectRelations"]

  # CHECK V1 REVIEW DATA EXISTS

  catch (:error_404) do
  objectRelations.each do |object|
    begin
      object_response = RestClient.get "http://content-api.ign.com/v1/games/#{object}.json"
    rescue
      throw :error_404
    end
    game_data = JSON.parse(object_response.body)
    if game_data['game']['reviewUrl'].to_s.match(/com\/articles\//)
      #puts "PASS: http://content-api.ign.com/v1/games/#{object}.json"
    else
      #puts "FAILURE:"
      puts "http://content-api.ign.com/v1/games/#{object}.json"
      puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
    end
  end #end objectRelations iteration
  end #end catch

  # CHECK V3 REVIEW DATA EXISTS

  catch (:error_404) do
    objectRelations.each do |object|
      begin
        object_response = RestClient.get "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
      rescue
        throw :error_404
      end
      game_data = JSON.parse(object_response.body)
      game_data['data'].each do |game_data|
        if game_data['metadata']['region'] == 'US'
          begin
            game_data['network']['ign']['review']['score']
          rescue
            #puts "FAILURE:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
            #puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            next
          end
          if (game_data['network']['ign']['review']['score'].to_s.length > 0) & game_data['legacyData']['reviewUrl'].to_s.match(/com\/articles\//)
            #puts "PASS: http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
          else
            #puts "FAILURE:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
            #puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          end
        end
      end
      puts "."
    end #end objectRelations iteration
  end #end catch

end #end article iteration

puts ""
puts "--------------------- GAME PREVIEWS ---------------------"
puts ""

url = "http://apis.lan.ign.com/article/v3/articles/search?q="+game_preview_articles.to_s
url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
response = RestClient.get url
data = JSON.parse(response.body)
data['data'].each do |article|
  
  objectRelations = []
  objectRelations = article["legacyData"]["objectRelations"]

  # CHECK V1 PREVIEW DATA EXISTS

  catch (:error_404) do
  objectRelations.each do |object|
    begin
      object_response = RestClient.get "http://content-api.ign.com/v1/games/#{object}.json"
    rescue
      throw :error_404
    end
    game_data = JSON.parse(object_response.body)
    if game_data['game']['previewUrl'].to_s.match(/com\/articles\//) || game_data['game']['previewUrl'].to_s.match(/\/articles\//)
      #puts "PASS: http://content-api.ign.com/v1/games/#{object}.json"
    else
      #puts "FAILURE:"
      puts "http://content-api.ign.com/v1/games/#{object}.json"
      puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
    end
  end #end objectRelations iteration
  puts "."
  end #end catch

  # CHECK V3 PREVIEW DATA EXISTS

  catch (:error_404) do
    objectRelations.each do |object|
      begin
        object_response = RestClient.get "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
      rescue
        throw :error_404
      end
      game_data = JSON.parse(object_response.body)
      game_data['data'].each do |game_data|
        if game_data['metadata']['region'] == 'US'
          if game_data.has_key?('legacyData')
            if game_data['legacyData']['previewUrl'].to_s.match(/com\/articles\//)
              #puts "PASS: http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
            else
              #puts "FAILURE:"
              puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
              puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            end
          else
            #puts "FAILURE:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          end
        end
      end
    end #end objectRelations iteration
    puts "."
  end #end catch
    
end #end article iteration



