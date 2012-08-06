module ObjectPostSearch

  def update_with_review_score
    {
      :network => {
        :ign => {
          :review => {
            :metadata => {
              :publishDate => "2012-03-06T08:00:00+0000"
            },
            :system => "ign-games",
            :score => 9.5,
            :editorsChoice => true
          }
        }
      }
    }.to_json
  end

  def create_release_draft(num)
    {
      "metadata" => {
        "name" => "Media QA Test Release #{num}"
      }
    }.to_json
  end

  def update_release_draft
    {
      "metadata" => {
          "region" => "UK"
      }
    }.to_json
  end

  def update_release_published(game_id,company_id,company_2_id,feature_id,feature_2_id,genre_id,genre_2_id,hardware_id,movie_id,book_id)
    {
    :metadata => {
      :releaseDate=> {
        :date=> "2012-03-06",
        :status=> "released",
        :display=> "March 6, 2012"
      },
      :tagLine=> "qa tag line",
      :description=> "qa-test description",
      :shortDescription=> "qa-test shortDescription",
      :alternateNames=> ["qa-test alternateNames 1","qa-test alternateNames 2" ],
      :game=> {
        :gameId=> game_id
      },
      :movie=> {
        :movieId=> movie_id
      },
      :book=> {
          :bookId=> book_id
      }
    }, # END METADATA
    :companies=> {
      :developers=> [{:companyId=> company_id}],
      :publishers=> [{:companyId=> company_id}],
      :distributors=> [{:companyId=> company_id}],
      :producers=> [{:companyId=> company_id}],
      :effects=> [{:companyId=> company_id}]
    }, # END COMPANIES
    :content=> {
      :features=> [
        "qa-test feature 1",
        "qa-test feature 2"
      ],
      :mediaType => "theater",
      :runTime => 65,
      :synopsis => "qa synopsis",
      :supports=> [
        {
        :featureId=> feature_id
        },
        {
        :featureId=> feature_2_id
        }
      ],
      :rating=> {
        :system=> "ESRB",
        :description=> [
          "qa-test description 1",
          "qa-test description 2"
        ],
        :rating=> "M",
        :summary=> "qa-test summary"
      },
      :primaryGenre=> {
        :genreId=> genre_id
      },
      :secondaryGenre=> {
        :genreId=> genre_2_id
      },
      :additionalGenres => [{:genreId=> genre_id},{:genreId=> genre_2_id}]
    }, # END CONTENT
    :hardware=> {
      :platform=> {
        :hardwareId=> hardware_id
      }
    }, # END HARDWARE
    :legacyData=> {
      :boxArt=> [
        {
        :url=> "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_60w.jpg",
        :height=> 85,
        :width=> 60,
        :positionId=> 19
        },
        {
        :url=> "http://pspmedia.ign.com/ps-vita/image/object/142/14235014/mass_effect_3_360_mboxart_90h.jpg",
        :height=> 90,
        :width=> 65,
        :positionId=> 17
        }
      ],
      :guideUrl=> "http://www.ign.com/wikis/mass-effect-3",
      :reviewUrl=> "http://xbox360.ign.com/articles/121/1219445p1.html",
      :previewUrl=> "http://comics.ign.com/articles/122/1222700p1.html"
    }, # END LEGACY DATA
    }.to_json
  end

  def update_objects(game_id,company_id,feature_id,feature_2_id,genre_id,genre_2_id,hardware_id,movie_id)
    {
      :metadata => {
          :game=> {
              :gameId=> game_id
          },
          :movie=> {
              :movieId=> movie_id
          }
      }, # END METADATA
      :companies=> {
          :developers=> [{:companyId=> company_id}],
          :publishers=> [{:companyId=> company_id}],
          :distributors=> [{:companyId=> company_id}],
          :producers=> [{:companyId=> company_id}],
          :effects=> [{:companyId=> company_id}]
      }, # END COMPANIES
      :content=> {
          :supports=> [
              {
                  :featureId=> feature_id
              },
              {
                  :featureId=> feature_2_id
              }
          ],
          :primaryGenre=> {
              :genreId=> genre_id
          },
          :secondaryGenre=> {
              :genreId=> genre_2_id
          },
          :additionalGenres => [{:genreId=> genre_id},{:genreId=> genre_2_id}]
      }, # END CONTENT
      :hardware=> {
          :platform=> {
              :hardwareId=> hardware_id
          }
      } # END HARDWARE
    }.to_json
  end

  def create_release_body(num,game_id,company_id,feature_id,genre_id,genre2_id,hardware_id,market_id,movie_id,book_id)
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
          "game" => {"gameId" => game_id.to_s},
          "movie" => {"movieId" => movie_id.to_s},
          "book" => {"bookId" => book_id.to_s}
      }, #end metadata
      "companies" => {
          "developers" => [{"companyId" => company_id.to_s}],
          "publishers" => [{"companyId" => company_id.to_s}],
          "distributors" => [{"companyId" => company_id.to_s}],
          "producers" => [{"companyId" => company_id.to_s}],
          "effects" => [{"companyId" => company_id.to_s}]
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
          "additionalGenres" => [{"genreId" => genre_id.to_s},{"genreId" => genre2_id.to_s},],
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
            "summary" => "rating summary updated"
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
        "valueOneLabel" => "vol one label"
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

  def create_movie_body(slug)
    {
      "metadata" => {
        "slug" => slug.to_s,
        "type" => "theater"
      }
    }.to_json
  end

  def create_volume_body(num,slug)
    {
        "metadata" => {
            "name" => "QA Test Volume #{num}",
            "slug" => slug.to_s,
            "state" => "published",
            "type" => "novel",
            "misspelledNames" => ['misspelled one','misspelled two']
        }
    }.to_json
  end

  def create_book_body(slug,vol)
    {
        "metadata" => {
            "slug" => slug.to_s,
            "volume"=>{"volumeId"=>vol}
        }
    }.to_json
  end

  def create_person_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s,
            "name" => "QA Test Person #{num}",

            "misspelledNames" => ["misspelled name one"],
            "description" => "person description"
        },
        "biography" => {
            "profile" => "person profile",
            "gender" => "male",
            "birth" =>  {
              # add name in update "name" => "birth name",
              "date" => "1974-01-30",
              "place" => "birth place"
            }
        }
    }.to_json
  end

  def create_character_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s,
            "name" => "QA Test Character #{num}",
            "alternateNames" => ["alt name one"],
            "firstAppearance" => "first appearance",
            # add description in update "description" => "character description"
        },
        "biography" => {
            # add in update "base" => "character base",
            "profile" => "character profile",
            "identity" => "character identity"
        }
    }.to_json
  end

  def create_roletype_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s,
            "name" => "QA Test Role #{num}",
        }
    }.to_json
  end

  def create_role_body(num,slug,movie_id,character_id,roletype_id,game_id,book_id,person_id)
    {
        "metadata" => {
            "lead" => false,
            "slug" => slug.to_s,
            "name" => "QA Test Role #{num}",
            "alternateNames" => ["alt name"],
            "commonName" => "common name",
            "description" => "company description",
            "movie" => {"movieId" => movie_id.to_s},
            "character" => {"characterId" => character_id.to_s},
            "roleType" => {"roleTypeId" => roletype_id.to_s},
            "game" => {"gameId" => game_id.to_s},
            "book" => {"bookId" => book_id.to_s},
            "person" => {"personId" => person_id.to_s}
        },
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
        "valueOneLabel" => "val one label updated",
        "valueTwoLabel" => "val two label added"
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

  def update_movie_body(slug)
    {
        "metadata" => {
            "slug" => slug.to_s+"-updated",
            "type" => "on-demand"
        }
    }.to_json
  end

  def update_volume_body(num,slug)
    {
        "metadata" => {
            "name" => "QA Test Volume #{num} updated", #changed
            "slug" => slug.to_s+"-updated", #changed
            "description" => "qa volume description", #added
            "type" => "comic", #changed
            "commonName" => "qa common name",
            "misspelledNames" => ['misspelled one updated','misspelled two updated','misspelled three updated'] #changed one and two; added three
        }
    }.to_json
  end

  def update_book_body(slug)
    {
        "metadata" => {
            "slug" => slug.to_s+"-updated", #changed
            "order" => 11 #added
        }
    }.to_json
  end

  def update_person_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s+"-updated", #changed
            "name" => "QA Test Person #{num} updated", #changed

            "misspelledNames" => ["misspelled name one updated", "misspelled name two"], #changed
            "description" => "person description updated" #changed
        },
    }.to_json
  end

  def update_character_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s+"-updated", #changed
            "name" => "QA Test Character #{num} updated", #changed
            "alternateNames" => ["alt name one updated", "alt name two"], #changed
            "firstAppearance" => "first appearance updated", #changed
            "description" => "character description" #added
        }
    }.to_json
  end

  def update_roletype_body(num,slug)
    {
        "metadata" => {
            "slug" => slug.to_s+"-updated", #changed
            "name" => "QA Test Role #{num} updated", #changed
        }
    }.to_json
  end

end