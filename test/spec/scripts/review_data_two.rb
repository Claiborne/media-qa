require 'oci8'
require 'dbi'
require 'rspec'
require 'nokogiri'
require 'configuration'
require 'rest_client'
require 'json'

dev_connect = "DBI:OCI8:media-dev-nib-db-01.sfdev.colo.ignops.com:1521/nibdb"
dev_user = "publish"
dev_pass = "publishdev"

connect = "DBI:OCI8:nibdb4.las1.colo.ignops.com:1521/nibdb"
user = "publish"
pass = "saturn1"

def ent_review_articles
  {"matchRule"=>"matchAll",
   "count"=>20,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {"field"=>"tags.slug",
        "condition"=>"containsNone",
        "value"=>"games"
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

def ent_preview_articles
  {"matchRule"=>"matchAll",
   "count"=>15,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {"field"=>"tags.slug",
        "condition"=>"containsNone",
        "value"=>"games"
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

begin

  #db = DBI.connect(dev_connect,dev_user,dev_pass)
  db = DBI.connect(connect,user,pass)

  puts ""
  puts "--------------------- REVIEWS ---------------------"
  puts ""

  url = "http://apis.lan.ign.com/article/v3/articles/search?q="+ent_review_articles.to_s
  url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  response = RestClient.get url
  data = JSON.parse(response.body)
  objects = []
  data['data'].each do |article|

    if article.has_key?('legacyData')
      if article["legacyData"].has_key?('objectRelations')
        objectRelations = article["legacyData"]["objectRelations"]
      end
    else
      objectRelations = []
    end

    objectRelations.each do |obj|
      sleep 0.5
      x = db.execute("SELECT review_url FROM obj_network_resources WHERE obj_id = '#{obj}' and network = '12'")

      x.fetch_hash do |row|
        if row['REVIEW_URL'] == nil
          puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          puts obj
        else
        end
      end

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
                #puts "--------> FAILURE:"
                puts "--------> http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
                #puts "--------> http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
                puts ""
                next
              end
              if (game_data['network']['ign']['review']['score'].to_s.length > 0) & game_data['legacyData']['reviewUrl'].to_s.match(/com\/articles\//)
                #puts "PASS: http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
              else
                #puts "--------> FAILURE:"
                puts "--------> http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
                #puts "--------> http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
                puts ""
              end
            end
          end
        end #end objectRelations iteration
      end #end catch

    end
  end

  # END REVIEWS
  puts ""
  puts "--------------------- PREVIEWS ---------------------"
  puts ""

  url = "http://apis.lan.ign.com/article/v3/articles/search?q="+ent_preview_articles.to_s
  url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  response = RestClient.get url
  data = JSON.parse(response.body)
  objects = []
  data['data'].each do |article|

    if article.has_key?('legacyData')
      if article["legacyData"].has_key?('objectRelations')
        objectRelations = article["legacyData"]["objectRelations"]
      end
    else
      objectRelations = []
    end

    objectRelations.each do |obj|
      sleep 0.5
      x = db.execute("SELECT preview_url FROM obj_network_resources WHERE obj_id = '#{obj}' and network = '12'")

      x.fetch_hash do |row|
        if row['PREVIEW_URL'] == nil
          puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          puts obj
        else
        end
      end

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
                  #puts "--------> FAILURE:"
                  puts "--------> http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
                  #puts "--------> http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
                  puts ""
                end
              else
                #puts "--------> FAILURE:"
                puts "--------> http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}"
                #puts "--------> http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
                puts ""
              end
            end
          end
        end #end objectRelations iteration
      end #end catch

    end
  end

rescue => e
  puts e.class.to_s
  puts e.message.to_s
ensure
  db.disconnect if db
end