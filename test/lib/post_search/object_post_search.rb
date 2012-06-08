module ObjectPostSearch
  
  def create_game_body(slug)
    {
      "metadata" => {
        "slug" => slug.to_s
      }
    }.to_json
  end
  
  def create_company_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "name" => "QA Test Company #{num}",
        "alternateNames" => ["alt name"],
        "commonName" => "common name",
        "description" => "company description"
      },
      "contact" => {
        "address" => "company address",
        "phone" => "company phone"
      }
    }.to_json
  end
  
  def create_feature_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "name" => "QA Test Feature #{num}",
        "description" => "feature description",
        "valueOneLabel" => "vol one lable"
      }
    }.to_json
  end
  
  def create_genre_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "name" => "QA Test Genre #{num}",
        "description" => "genre description"
      }
    }.to_json
  end
  
  def create_hardware_body(num,slug,id)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "name" => "QA Test Hardware #{num}",
        "description" => "hardware description",
        "type" => "arcade",
        "releaseDate" => {
          "date" => "2020-11-11",
          "display"  => "Q4 2020",
          "status" => "unreleased"
        }
      },
      "companies" => {
        "manufacturers" => [
          {
            "companyId" => id.to_s
          }      
          ]
      }
    }.to_json
  end
  
  def create_market_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "name" => "QA Test Market #{num}",
        "description" => "market description"
      }
    }.to_json
  end
  
  def create_release_body(num,game_id,company_id,feature_id,genre_id,hardware_id,market_id)
    {
      "metadata" => {
        "name" => "QA Test Release #{num}",
        "alternateNames" => ["alt name"],
        "commonName" => "common name",
        "editionName" => "edition name",
        "editionDescription" => "edition description",
        "description" => "release description",
        "region" => "UK",
        "releaseDate" => {
          "date" => "2020-12-31"
        },
        "game" => {"gameId" => game_id.to_s}
      }, #end metadata
      "companies" => {
        "developers" => [{"companyId" => company_id.to_s}],
        "publishers" => [{"companyId" => company_id.to_s}]
      }, #end companies
      "content" => {
        "rating" => {
          "rating" => "M",
          "system" => "ESRB",
          "description" => ["Blood"],
          "summary" => "rating summary"
        }, #end rating
        "features" => ["feature description"],
        "supports" => [{"featureId" => feature_id.to_s}],
        "primaryGenre" => {"genreId" => genre_id.to_s},
        "minimumRequirements" => ["min requirements"]
      }, #end content
      "hardware" => {
        "platform" => {"hardwareId" => hardware_id.to_s},
        "supports" => [{"hardwareId" => hardware_id.to_s}]
      }, #end hardware
      "purchasing" => {
        "msrp" => {
          "price" => 59.99,
          "currency" => "USD"
        },
        "buy" => [{"marketId" => market_id.to_s}]
      } #end purchasing
    }.to_json
  end
  
  def update_game_body(slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated"
      }
    }.to_json
  end
  
  def update_company_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated",
        "name" => "QA Test Company #{num} updated",
        "alternateNames" => ["alt name updated"],
        "commonName" => "common name updated",
        "description" => "company description updated"
      },
      "contact" => {
        "address" => "company address updated",
        "phone" => "company phone updated",
        "url" => "company url added"
      }
    }.to_json
  end
  
  def update_feature_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated",
        "name" => "QA Test Feature #{num} updated",
        "description" => "feature description updated",
        "valueOneLabel" => "val one labbel updated",
        "valueTwoLabel" => "val two labbel added"
      }
    }.to_json
  end
  
  def update_genre_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated",
        "name" => "QA Test Genre #{num} updated",
        "description" => "genre description updated"
      }
    }.to_json
  end
  
  def update_hardware_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated",
        "name" => "QA Test Hardware #{num} updated",
        "shortName" => "QATH added",
        "description" => "hardware description updated",
        "type" => "console",
        "releaseDate" => {
          "date" => "2011-12-12",
          "display"  => "Q4 2011",
          "status" => "released"
        }
      },
      "purchasing" => {
        "msrp" => {
          "price" => 599.99,
          "currency" => "USD"
        }
      }
    }.to_json
  end
  
  def update_market_body(num,slug)
    {
      "metadata" => {
        "slug" => slug.to_s+"-updated",
        "name" => "QA Test Market #{num} updated",
        "description" => "market description updated"
      }
    }.to_json
  end
  
  def update_release_body(num)
     {
       "metadata" => {
         "name" => "QA Test Release #{num} updated",
         "alternateNames" => ["alt name updated"],
         "commonName" => "common name updated",
         "editionName" => "edition name updated",
         "editionDescription" => "edition description updated",
         "description" => "release description updated",
         "region" => "US", # updated
         "releaseDate" => {
           "date" => "2020-12-31"
         }
       }, #end metadata
       "content" => {
         "rating" => {
           "rating" => "T", # updated
           "system" => "ESRB",
           "description" => ["Blood"],
           "summary" => "rating summary udated"
         }, #end rating
         "features" => ["feature description updated"],
         "minimumRequirements" => ["min requirements updated"]
       }, #end content
       "network" => { # this is added
         "ign" => {
           "review" => {
             "score" => 7.0, # updated
             "system" => "ign-games"
           } #end review
         } #end ign
       }, #end network
       "purchasing" => {
         "msrp" => {
           "price" => 59.99,
           "currency" => "USD"
         }
       } #end purchasing
     }.to_json
   end
  
end