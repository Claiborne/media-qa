require 'rest_client'
require 'json'

@token = '2b405d3ee81080c402f9de4897a377056c86f1bb'

def new_release_min
  {
      "metadata" => {
          "name" => "Test Game 1",
          "slug" => "test-game-1",
          "state" => "draft",
          "region" => "US",
          "releaseDateDisplay" => "March 7 2012"
      },
      "hardware" => {
              "platform"  => { 
                  "hardwareId" => "4f9597e399e75b8215d853df"
              }
      }
  }.to_json
end

def new_release
  {
      #"releaseId" => "4f8e020d99e7ba201065dc8b",
      "metadata" => {
          #"legacyId" => 110694,
          "name" => "Test Game 2",
          "alternateNames" => [
              "QA Game 2"
          ],
          "commonName" => "Test Game 2",
          "misspelledNames" => [
              "Testgame 1"
          ],
          "editionName" => "Standard",
          "editionDescription" => "Editorial description here",
          "shortDescription" => "Short description here",
          "state" => "draft",
          "region" => "US",
          "releaseDate" => "2012-03-07",
          "releaseDateDisplay" => "March 7 2012",
          #"game" => {
              #"gameId" => "4f6d5043938617c062ceefc4",
              #"metadata" => {
                  #"slug" => "test-game-1"
              #}
          #}#,
          #"images" => {
              #"highlight" => {
                  #"imageId" => "4df6ddf8759a4c62bd8b4c50",
                      #"asset" => {
                          #"ur"l => "http://assets.ign.com/images/2012/04/02/4df6ddf8759a4c62bd8b4c50.jpg"
                      #}
              #},
              #"boxArt" => {
                  #"imageId" => "4df6ddf8759a4c62bd8b4c51",
                  #"asset" => {
                      #"url" => "http://assets.ign.com/images/2012/04/02/4df6ddf8759a4c62bd8b4c51.jpg"
                  #}
              #}
          #}
      },
      "companies" => {
          "developers" => [
              {
                  "companyId" => "4f7381f586a83c04464471c7"#,
                  #"metadata" => {
                      #"name" => "Bioware",
                      #"description" => "desc",
                      #"legacyId" => 26717,
                      #"slug" => "bioware"
                  #}
              }
          ],
          "publishers" => [
              {
                  "companyId" => "4f7381d086a83c04464471c6"#,
                  #"metadata" => {
                      #"name" => "Electronic Arts",
                      #"description" => "desc",
                      #"legacyId" => 25025,
                      #"slug" => "electronic-arts"
                 # }
              }
          ],
          "distributors" => [ ],
      },
      "content" => {
          "rating" => {
              "rating" => "M",
              "system" => "ESRB",
              "description" => [
                  "Blood",
                  "Partial Nudity",
                  "Sexual Content",
                  "Strong Language",
                  "Violence"
              ],
              "summary" => "summary here"
          },
          "features" => [
              "feature blurb one",
              "feature blurb two"
          ],
          "supports" => [
              {
                  "featureId" => "4f85c5eb86a8cc600fe4e7f5",
                  #"metadata" => {
                      #"name" => "Online Co-Op Multiplayer",
                      #"description" => "Cooperate with other players over the Internets",
                      #"slug" => "online-co-op-multiplayer",
                      #"type" => "online-multiplayer",
                      #"legacyId" => 582375,
                      #"valueOneLabel" => "Minimum Players",
                      #"valueTwoLabel" => "Maximum Players"
                  #},
                  "valueOne" => 2,
                  "valueTwo" => 4
              }
          ],
          "requires" => [ ],
          "genres" => [
              {
                  "genreId" => "4f612655ac158ede14000031"#,
                  #"metadata" => {
                      #"name" => "RPG",
                      #"description" => "Role-Playing Game",
                      #"slug" => "rpg",
                      #"legacyId" => 12345,
                      #"type" => "primary"
                  #}
              }
          ],
          "mediaSize" => "11GB download",
          "minimumRequirements" => [
              "OS - Windows XP SP3/Vista SP1, Win 7",
              "CPU: 1.8 GHz Intel Core 2 Duo (equivalent AMD CPU)",
              "RAM: 1GB for XP / 2GB RAM for Vista/Win 7",
              "Disc Drive: 1x speed",
              "Hard Drive: 2.5 GB of free space",
              "Video: 256 MB (with Pixel Shader 3.0 support)",
              "Sound: DirectX 9.0c compatible",
              "DirectX: DirectX 9.0c August 2009 (included)"
          ],
          "recommendedRequirements" => [
              "OS: Windows XP SP3/Vista SP1, Win 7",
              "CPU: 2.4 GHz Intel Core 2 Duo (equivalent AMD CPU)",
              "RAM: 2GB for XP / 4GB RAM for Vista/Win 7",
              "Disc Drive: 1x speed",
              "Hard Drive: 2.5 GB of free space",
              "Video: AMD/ATI Radeon HD 4850 512 MB or greater, NVidia GeForce 9800 GT 512 MB or greater",
              "Sound: DirectX 9.0c compatible"
          ]
      },
      #"editorial" => {
          #"review" => {
              #"articleId" => "4f4996d88e88c564e20004a4",
              #"metadata" => {
                  #"slug" => "mass-effect-3-review",
                  #"publishDate" => "2012-03-06T08:01:00+0000"
              #},
              #"score" => 9.5,
              #"system" => "ign-games",
              #"editorsChoice" => true
          #}
      #},
      "hardware" => {
          "platform" => {
              "hardwareId" => "4f7391c686a84c6ac3933101"#,
              #"metadata" => {
                  #"name" => "Xbox 360",
                  #"shortName" => "X360",
                  #"description" => "The Xbox 360 is the second video game console produced by Microsoft and the successor to the Xbox.",
                  #"slug" => "xbox-360",
                  #"legacyId" => 661955,
                  #"type" => "platform"
              #}
          },
          "supports" => [
              {
                  "hardwareId" => "4f73926586a84c6ac3933102"#,
                  #"metadata" => {
                      #"name" => "Kinect",
                      #"description" => "Kinect for Xbox 360 brings games and entertainment to life in extraordinary new ways without using a controller.",
                      #"slug" => "kinect",
                      #"legacyId" => 14357198,
                      #"type" => "input-device"
                  #}
              }
          ],
          "requires" => [ ]
      },
      "purchasing" => {
          "msrp" => {
              "price" => 49.99,
              "currency" => "USD"
          },
          "markets" => [
              {
                  "marketId" => "4f864e11b2566ccc01019231"#,
                  #"metadata" => {
                      #"name" => "Origin",
                      #"description" => "EA's lame attempt at Steam",
                      #"slug" => "origin"
                  #}
              }
          ]
      },
      "system" => {
          #"createdAt" => "2012-03-14T23:14:30+0000",
          #"createdBy" => "28456",
          #"updatedAt" => "2012-03-14T23:14:30+0000",
          #"updatedBy" => "28456",
          "isActive" => false
      }
  }.to_json
end

def release_search
  {
    "rules"=>[
      {
        "field"=>"editorial.rating",
        "condition"=>"exists",
        "value"=>""
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>45,
    "sortBy"=>"metadata.releaseDate",
    "sortOrder"=>"asc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to_json
end

def reviews
{"matchRule"=>"matchAll",
  "startIndex"=>0,
  "count"=>26,
  "sortBy"=>"network.ign.review.metadata.publishDate",
  "sortOrder"=>"desc",
  "states"=>["published"],
  "regions"=>["US"],
  "rules"=>[{"field"=>"network.ign.review.score",
    "condition"=>"exists","value"=>""},
    {"field"=>"hardware.platform.metadata.slug",
      "condition"=>"term","value"=>"ps3"},
      {"field"=>"network.ign.review.metadata.publishDate",
        "condition"=>"range","value"=>",2012-05-07"}]}.to_json
end

def update_this
  {
    "network" => {
      "ign" => {
        "review" => {
          "score" => 5.0,
          "editorsChoice" => false
        } #end review
      } #end ign
    }, #end network
  }.to_json
end

def update_market_body
  {
    "metadata" => {
      "slug" => "slug-updated-2",
      "name" => "QA Test Market updated-2",
      "description" => "market description updated-2"
    }
  }.to_json
end

def bioware_games_by_dev_name
  {
    "rules"=>[
      {
        "field"=>"companies.developers.metadata.name",
        "condition"=>"term",
        "value"=>"bioware"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>25,
    "states"=>["published"]
  }.to_json
end

def published
  {
    "startIndex"=>0,
    "count"=>25,
    "states"=>["published"],
    "regions"=>["IE"]
  }.to_json
end

def testing
  {
    "rules"=>[
      {
        "field"=>"hardware.platform.metadata.slug",
        "condition"=>"term",
        "value"=>"xbox-360"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>4,
    "count"=>20,
    "sortBy"=>"metadata.releaseDate.date",
    "sortOrder"=>"desc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to_json
end

def review_index
  
  # www.ign.com/games/reviews
  
  {
    "rules"=>[
      {
        "field"=>"network.ign.review.score",
        "condition"=>"range",
        "value"=>"0.1,",
      }, 
      {
        "field"=>"hardware.platform.metadata.slug",
        "condition"=>"term",
        "value"=>"3ds"
      },
      {
        "field"=>"content.primaryGenre.metadata.slug",
        "condition"=>"term",
        "value"=>"sports"
      },
      {
        "field"=>"network.ign.review.metadata.publishDate",
        "condition"=>"range",
        "value"=>",2012-05-16T13:36:29-0700"
      }
    ],
    "matchRule"=>"matchAll",
    "startIndex"=>0,
    "count"=>25,
    "sortBy"=>"network.ign.review.metadata.publishDate",
    "sortOrder"=>"desc",
    "states"=>["published"],
    "regions"=>["US"]
  }.to.json
end

def editors_choice_index
  
  # www.ign.com/games/editors-choice

end

def movie_search
  {
      "rules"=>[
          {
              "field"=>"metadata.movie.movieId",
              "condition"=>"exists",
              "value"=>""
          }
      ],
      "startIndex"=>0,
      "count"=>200,
  }.to_json
end

#@url = "http://10.92.218.26:8080/releases/4f8e020d99e7ba201065dc8b"
#@response = RestClient.put @url, new_release_min, :content_type => "application/json"
#@data = JSON.parse(@response.body)
#File.open('/Users/wclaiborne/Desktop/object_api.json', 'w') {|f| f.write(@response.to_s) }

=begin
@url = "http://10.92.218.26:8080/releases/search"
@response = RestClient.post @url, release_search, :content_type => "application/json"
@data = JSON.parse(@response.body)
File.open('/Users/wclaiborne/Desktop/object_api.json', 'w') {|f| f.write(@response.to_s) }
=end

#@url = "http://10.92.218.26:8080/markets/4f9ec4af99e7cb98fa835b92?oauth_token=#{@token}"

#@url = "http://10.92.218.26:8080/releases/search"

#@url = "http://10.92.218.26:8080/releases/search"


@url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3/releases/search?q="+movie_search.to_s
@url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
begin
  @response = RestClient.get @url
rescue => e
    raise Exception.new(e.message+" "+e.response.to_s)
end
@data = JSON.parse(@response.body)
File.open('/Users/wclaiborne/Desktop/object_api.json', 'w') {|f| f.write(@response.to_s) }

#puts"DATA"
#puts"-------------------------"
#puts @data





