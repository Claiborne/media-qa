require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'

def game_review_articles
  {"matchRule"=>"matchAll",
   "count"=>20,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {
       "field"=>"tags.slug",
       "condition"=>"containsOne",
       "value"=>"games,game"
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
   "count"=>20,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {
       "field"=>"tags.slug",
       "condition"=>"containsOne",
       "value"=>"games,game"
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

  # CHECK V3 REVIEW DATA EXISTS

  catch (:error_404) do
    objectRelations.each do |object|
      begin
        object_response = RestClient.get "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
      rescue
        throw :error_404
      end
      game_data = JSON.parse(object_response.body)
      game_data['data'].each do |game_data|
        if game_data['metadata']['region'] == 'US'
          #CHECK SCORE
          begin
            game_data['network']['ign']['review']['score']
          rescue
            #puts "FAILURE:"
            puts "SCORE MISSING:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            next
          end
          if (game_data['network']['ign']['review']['score'].to_s.length > 0) & game_data['legacyData']['reviewUrl'].to_s.match(/com\/articles\//)
            #puts "PASS: http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
          else
            #puts "FAILURE:"
            puts "SCORE: #{game_data['network']['ign']['review']['score']}:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          end

          #CHECK REVIEW URL
          begin
            game_data['legacyData']['reviewUrl']
          rescue
            puts "REVIEW URL MISSING: "
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            next
          end
          if (game_data['legacyData']['reviewUrl'].to_s.match(/blogs/) || game_data['legacyData']['reviewUrl'].to_s.length < 1 || game_data['legacyData']['reviewUrl'] == nil || game_data['legacyData']['reviewUrl'].to_s.match(/\/preview/))
            #puts "FAILURE:"
            puts "REVIEW URL #{game_data['legacyData']['reviewUrl']}:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          else
          end
        end
      end
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

  # CHECK V3 PREVIEW DATA EXISTS

  catch (:error_404) do
    objectRelations.each do |object|
      begin
        object_response = RestClient.get "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
      rescue
        throw :error_404
      end
      game_data = JSON.parse(object_response.body)
      game_data['data'].each do |game_data|
        if game_data['metadata']['region'] == 'US'
          begin
            game_data['legacyData']['previewUrl']
          rescue
            puts "PREVIEW URL MISSING:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1" 
            next
          end
          if game_data['legacyData']['previewUrl']
            if game_data['legacyData']['previewUrl'].to_s.match(/com\/articles\//)
              #puts "PASS: http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            else
              #puts "FAILURE:"
              puts "PREIVEW URL: #{game_data['legacyData']['previewUrl']}:"
              puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
              puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
              next
            end
          else
            #puts "FAILURE:"
            puts "PREVIEW URL MISSING:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            next
          end
          #CHECK PREVIEW URL
          begin
            game_data['legacyData']['previewUrl']
          rescue
            #puts "FAILURE:"
            puts  "PREVIEW URL MISSING:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            next
          end
          if (game_data['legacyData']['previewUrl'].to_s.match(/blogs/) || game_data['legacyData']['previewUrl'].to_s.length < 1 || game_data['legacyData']['previewUrl'] == nil || game_data['legacyData']['previewUrl'].to_s.match(/\/preview/))
            #puts "FAILURE:"
            puts "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
            puts "PREVIEW URL #{game_data['legacyData']['reviewUrl']}"
            puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          else
          end
        end
      end
    end #end objectRelations iteration
  end #end catch

end #end article iteration


