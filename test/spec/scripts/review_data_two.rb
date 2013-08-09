#require 'dbi'
#require 'oci8'
require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'

#dev_connect = "DBI:OCI8:media-dev-nib-db-01.sfdev.colo.ignops.com:1521/nibdb"
#dev_user = "publish"
#dev_pass = "publishdev"

#connect = "DBI:OCI8:nibdb4.las1.colo.ignops.com:1521/nibdb"
#user = "publish"
#pass = "saturn1"

wordpress_review_urls =[]
wordpress_preview_urls = []

def ent_review_articles
  {"matchRule"=>"matchAll",
   "count"=>60,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {"field"=>"tags.slug",
        "condition"=>"containsNone",
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

def ent_preview_articles
  {"matchRule"=>"matchAll",
   "count"=>15,
   "startIndex"=>0,
   "networks"=>"ign",
   "states"=>"published",
   "rules"=>[
       {"field"=>"tags.slug",
        "condition"=>"containsNone",
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

  #db = DBI.connect(dev_connect,dev_user,dev_pass)
  #db = DBI.connect(connect,user,pass)

  puts ""
  puts "--------------------- ENT REVIEWS ---------------------"
  puts ""

  url = "http://apis.lan.ign.com/article/v3/articles/search?q="+ent_review_articles.to_s
  url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  response = RestClient.get url
  data = JSON.parse(response.body)
  data['data'].each do |article|
    if article.has_key?('legacyData')
      if article["legacyData"].has_key?('objectRelations')
        objectRelations = article["legacyData"]["objectRelations"]
      end
    else
      objectRelations = []
    end
=begin
    objectRelations.each do |obj|
      x = db.execute("SELECT review_url, overall_rating FROM obj_network_resources WHERE obj_id = '#{obj}' and network = '12'")

      x.fetch_hash do |row|
        if (row['REVIEW_URL'] == nil || row['OVERALL_RATING'] == nil || row['OVERALL_RATING'] == 0 || row['OVERALL_RATING'] == 0.0 || row['REVIEW_URL'].to_s.match(/blogs/) || row['REVIEW_URL'].to_s.match(/\d\/preview/))
          puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
        else
        end
      end
    end
=end
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
            begin
              game_data['network']['ign']['review']['score']
            rescue
              wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
              next
            end
            begin
              game_data['legacyData']['reviewUrl']
            rescue
              wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
              next
            end
            if (game_data['network']['ign']['review']['score'].to_s.length < 1 || game_data['legacyData']['reviewUrl'].to_s.match(/blogs/) || game_data['legacyData']['reviewUrl'].to_s.length < 1 || game_data['network']['ign']['review']['score'] == nil || game_data['legacyData']['reviewUrl'] == nil || game_data['legacyData']['reviewUrl'].to_s.match(/\/preview/))
              wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            else
            end
          end
        end
      end
    end

    %w(episodes shows volumes).each do |o|
    catch (:error_404) do
      objectRelations.each do |object|
        begin
          object_response = RestClient.get "http://apis.lan.ign.com/object/v3/#{o}/legacyId/#{object}?fresh=true"
        rescue
          throw :error_404
        end
        game_data = JSON.parse(object_response.body)
        begin
          game_data['network']['ign']['review']['score']
        rescue
          wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          next
        end
        begin
          game_data['legacyData']['reviewUrl']
        rescue
          wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          next
        end
        if (game_data['network']['ign']['review']['score'].to_s.length < 1 || game_data['legacyData']['reviewUrl'].to_s.match(/blogs/) || game_data['legacyData']['reviewUrl'].to_s.length < 1 || game_data['network']['ign']['review']['score'] == nil || game_data['legacyData']['reviewUrl'] == nil || game_data['legacyData']['reviewUrl'].to_s.match(/\/preview/))
          wordpress_review_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
        else
        end
      end
    end
    end
  end

  puts wordpress_review_urls
  # END REVIEWS

  puts ""
  puts "--------------------- ENT PREVIEWS ---------------------"
  puts ""

  url = "http://apis.lan.ign.com/article/v3/articles/search?q="+ent_preview_articles.to_s
  url = url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  response = RestClient.get url
  data = JSON.parse(response.body)
  data['data'].each do |article|
    if article.has_key?('legacyData')
      if article["legacyData"].has_key?('objectRelations')
        objectRelations = article["legacyData"]["objectRelations"]
      end
    else
      objectRelations = []
    end
=begin
    objectRelations.each do |obj|
      x = db.execute("SELECT preview_url FROM obj_network_resources WHERE obj_id = '#{obj}' and network = '12'")

      x.fetch_hash do |row|
        if (row['PREVIEW_URL'].to_s.match(/\d\/preview/) || row['PREVIEW_URL'].to_s.match(/blogs/) || row['PREVIEW_URL'] == nil || row['PREVIEW_URL'] == "")
          puts "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
        else
        end
      end
    end
=end
    # CHECK V3 PREVIEW DATA EXISTS

      objectRelations.each do |object|
        begin
          object_response = RestClient.get "http://apis.lan.ign.com/object/v3/releases/legacyId/#{object}?fresh=true"
        rescue
          next
        end
        game_data = JSON.parse(object_response.body)
        game_data['data'].each do |game_data|
            begin
              game_data['legacyData']['previewUrl']
            rescue
              wordpress_preview_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
              next
            end
            if (game_data['legacyData']['previewUrl'].to_s.match(/blogs/) || game_data['legacyData']['previewUrl'] == nil || game_data['legacyData']['previewUrl'].to_s.length < 1 || game_data['legacyData']['reviewUrl'].to_s.match(/\/preview/))
              wordpress_preview_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
            else
          end
        end
      end

    %w(episodes shows volumes).each do |o|
      objectRelations.each do |object|
        begin
          object_response = RestClient.get "http://apis.lan.ign.com/object/v3/#{o}/legacyId/#{object}?fresh=true"
        rescue
          next
        end
        game_data = JSON.parse(object_response.body)
        begin
          game_data['legacyData']['previewUrl']
        rescue
          wordpress_preview_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
          next
        end
        if (game_data['legacyData']['previewUrl'].to_s.match(/blogs/) || game_data['legacyData']['previewUrl'] == nil || game_data['legacyData']['previewUrl'].to_s.length < 1 || game_data['legacyData']['reviewUrl'].to_s.match(/\/preview/))
          wordpress_preview_urls << "http://write.ign.com/wp-admin/post.php?post=#{article['refs']['wordpressId']}&action=edit&message=1"
        else
        end
      end
    end
  end
  puts wordpress_preview_urls
