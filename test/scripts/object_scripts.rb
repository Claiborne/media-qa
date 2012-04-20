require 'rest_client'
require 'json'

def new_release_min
  {
      #"releaseId" => "4f8e020d99e7ba201065dc8b",  
      "metadata" => {
          #"legacyId" => 110694,
          "name" => "Test Game 1",
          "alternateNames" => [
              "QA Game 1"
          ],
          "commonName" => "Test Game 1",
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
          #}
      },
      "companies" => {
            "developers" => [
            {
                "companyId" => "4f83a92e99e7d55699f3d137"#,
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
                "companyId" => "4f83a92e99e7d55699f3d137"#,
                #"metadata" => {
                    #"name" => "Electronic Arts",
                    #"description" => "desc",
                    #"legacyId" => 25025,
                    #"slug" => "electronic-arts"
               # }
            }
        ],
        "distributors" => [ ],
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


@url = "http://10.92.218.26:8080/releases/4f8e020d99e7ba201065dc8b"
@response = RestClient.put @url, new_release_min, :content_type => "application/json"
@data = JSON.parse(@response.body)
File.open('/Users/wclaiborne/Desktop/object_api.json', 'w') {|f| f.write(@response.to_s) }





