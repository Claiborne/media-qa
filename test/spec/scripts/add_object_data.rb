require 'rspec'
require 'rest_client'
require 'json'
require 'topaz_token'

describe "Add Comic Data", :comic => true do

  include TopazToken

  before(:all) do
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3"
    @token = return_topaz_token('object')
    Obj = ObjectApiJsonBodies.new
  end

  it "should create a volume" do
    res = JSON.parse (Obj.post "#@url/volumes?oauth_token=#@token", Obj.volume).body
    puts Obj.volume_id = res['volumeId']
  end

  it "should create a book" do
    res = JSON.parse (Obj.post "#@url/books?oauth_token=#@token", Obj.book(Obj.volume_id)).body
    puts Obj.book_id = res['bookId']
  end

  it "should create a comic company" do
    res = JSON.parse (Obj.post "#@url/companies?oauth_token=#@token", Obj.comic_company).body
    puts Obj.comic_company_id = res['companyId']
  end

  it "should create a comic release" do
    res = JSON.parse (Obj.post "#@url/releases?oauth_token=#@token", Obj.comic_release(Obj.book_id,Obj.comic_company_id)).body
    puts Obj.comic_release_id = res['releaseId']
  end

end

describe "Add TV Data", :tv => true do

  include TopazToken

  before(:all) do
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3"
    @token = return_topaz_token('object')
    Obj = ObjectApiJsonBodies.new
  end

  it "should create a show" do
    res = JSON.parse (Obj.post "#@url/shows?oauth_token=#@token", Obj.show).body
    puts Obj.show_id = res['showId']
  end

  it "should create a season" do
    res = JSON.parse (Obj.post "#@url/seasons?oauth_token=#@token", Obj.season(Obj.show_id)).body
    puts Obj.season_id = res['seasonId']
  end

  it "should create a tv release" do
    res = JSON.parse (Obj.post "#@url/releases?oauth_token=#@token", Obj.tv_release(Obj.season_id)).body
    puts Obj.tv_release_id = res['releaseId']
  end

end

describe "Add Stars Data", :stars => true do

  include TopazToken

  before(:all) do
    @url = "http://media-object-stg-services-01.sfdev.colo.ignops.com:8080/object/v3"
    @token = return_topaz_token('object')
    Obj = ObjectApiJsonBodies.new
  end

  it "should create a person" do
    res = JSON.parse (Obj.post "#@url/people?oauth_token=#@token", Obj.person).body
    puts Obj.person_id = res['personId']
  end

  it "should create a character" do
    co = JSON.parse (RestClient.get "#@url/companies/slug/dc-comics").body
    co = co['companyId']

    res = JSON.parse (Obj.post "#@url/characters?oauth_token=#@token", Obj.character(co)).body
    puts Obj.character_id = res['characterId']
  end

  it "should create a roletype" do
    res = JSON.parse (Obj.post "#@url/roletypes?oauth_token=#@token", Obj.roletype).body
    puts Obj.roletype_id = res['roleTypeId']
  end

  it "should create a role" do
    movie = JSON.parse (RestClient.get "#@url/movies/slug/the-dark-knight").body
    movie = movie['movieId']

    res = JSON.parse (Obj.post "#@url/roles?oauth_token=#@token", Obj.role(Obj.character_id,Obj.person_id,Obj.roletype_id,movie)).body
    puts Obj.role_id = res['roleId']
  end

end

class ObjectApiJsonBodies

  attr_accessor :comic_id, :book_id, :volume_id, :comic_release_id, :comic_company_id, :show_id, :season_id, :tv_release_id, :person_id, :character_id, :roletype_id, :role_id

  def post(url,body)
    RestClient.post url, body, :content_type => "application/json"
  end

  def person
    {
        "metadata"=> {
            "slug"=> "christian-bale",
            "legacyId"=> 913820,
            "name"=> "Christian Bale",
            "state"=> "published",
            "alternateNames"=> [],
            "misspelledNames"=> [
                "Christian Morgan Bale",
                "Christian Bail"
            ],
            "description"=> "Christian Bale is an actor, best known for his work on the films Empire of the Sun, Newsies, American Psycho, 3:10 To Yuma, Terminator Salvation and The Dark Knight."
        },
        "biography"=> {
            "profile"=> "Christian Charles Phillip Bale was born January 30, 1974, in Haverfordwest, Pembrokeshire, Wales. He is an actor who started as a child and has starred in a wide variety of films ranging from small budget independent films to studio blockbusters.

His film debut in 1986 in Anastasia: The Mystery of Anna, a made-for-TV movie, caught the attention of his co-star, Amy Irving, who was married to Steven Spielberg at the time. Irving recommended Bale for her husband's film Empire of the Sun for which he won \"Best Performance by a Juvenile Actor\", an award that was created for him.

In 1999, Bale starred as Patrick Bateman, a yuppie serial killer in the controversial film adaptation of the book by Brett Easton Ellis, American Psycho.

In 2004, Bale lost over sixty pounds by crash dieting for the role of a guilt ridden insomniac in The Machinist. Although the film was given limited release, it received positive reviews.  During the next six months, he dedicated himself to gaining over a hundred pounds and building muscle mass for the role of Bruce Wayne in Batman Begins. The film was a huge success for Warner Bros. taking in over $370 million worldwide.

Among Bale's other films of interest are Reign of Fire, Laurel Canyon, Velvet Goldmine and The Prestige.

Bale is a conservationist and an animal lover. He is a supporter of Greenpeace and the World Wildlife Fund.

He is married to Sandra Blazic and they have one daughter.",
            "gender"=> "male",
            "birth"=> {
                "name"=> "Christian Charles Philip Bale",
                "place"=> "Haverfordwest, Pembrokeshire, Wales, UK",
                "date"=> "1974-01-30"
            }
        },
        "legacyData"=> {
            "boxArt"=> [
                {
                    "width"=> 160,
                    "height"=> 247,
                    "url"=> "http://starsmedia.ign.com/stars/image/object/913/913820/christianbale_boxboxart_160w.jpg",
    "positionId"=> 5,
    }
    ]
    }
    }.to_json
  end

  def character(co)
    {
        "metadata"=> {
            "slug"=> "batman",
            "legacyId"=> 924128,
            "name"=> "Batman",
            "state"=> "published",
            "alternateNames"=> [
                "Bruce Wayne",
                "The Dark Knight",
                "Bats",
                "Matches Malone",
                "Batman of Zur-en-arrh"
            ],
            "misspelledNames"=> [
                "Bat-Man",
                "The Batman",
                "Zur en arrh"
            ],
            "description"=> "Created by Bob Kane and Bill Finger, Batman is the superhero star of the long-running DC Comics series since his first appearance in Detective Comics #27 in May 1939. Batman's secret identity is Bruce Wayne, the wealthy industrialist who dedicated his life to fighting crime after seeing his parents murdered.",
    "firstAppearance"=> "Detective Comics #27 (May 1939)"
    },
        "biography"=> {
        "profile"=> "Many great heroes are born out of tragedy, and for no one is this more true than Bruce Wayne. He was the only child in a family commonly regarded as Gotham City's finest. But his innocence was torn away the night his parents were murdered before his eyes. From that fateful night, Bruce dedicated himself to becoming the ultimate detective. For years he traveled the world, training himself both mentally and physically.

Upon his return to Gotham, he channeled his skills, his wealth, and his hatred of criminals into a new persona=> Batman. Since then he has waged a constant war on the superstitious criminals who plague Gotham's streets. Though he does not possess any superhuman skills, Batman's fighting ability and tactical mind are almost without equal among the superhuman community. Despite the countless lives he has saved, Batman's obsession never ceases. It seems that Bruce Wayne has become nothing more than a mask worn by the man who has become Batman.",
        "identity"=> "Bruce Wayne",
        "base"=> "Gotham City"
    },
        "companies"=> {
        "publishers"=> [
            {
                "companyId"=> co,
                "metadata"=> {
                    "slug"=> "dc-comics",
                    "legacyId"=> 734474,
                    "name"=> "DC Comics"
                }
            }
        ]
    },
        "legacyData"=> {
        "boxArt"=> [
            {
                "url"=> "http://starsmedia.ign.com/stars/image/object/924/924128/jimlee_batman_boxboxart_160w.jpg",
                "height"=> 226,
                "width"=> 160,
                "positionId"=> 5
            }
        ]
    }
    }.to_json
  end

  def roletype
    {
      "metadata"=> {
        "slug"=> "actor",
        "legacyId"=> 14208299,
        "name"=> "Actor",
      }
    }.to_json
  end

  def role(char,person,roletype,movie)
    {
      "metadata"=> {
        "legacyId"=> 940319,
        "duration"=> "",
        "lead"=> true,
        "characterName"=> "Bruce Wayne / Batman",
        "character"=> {
            "characterId"=> char
        },
        "person"=> {
            "personId"=> person
        },
        "roleType"=> {
            "roleTypeId"=> roletype
        },
        "movie"=> {
            "movieId"=> movie
        }
      }
    }.to_json

  end

  def show
    {
      "metadata"=> {
        "slug"=> "batman-the-animated-series",
        "legacyId"=> 909538,
        "name"=> "Batman: The Animated Series",
        "state"=> "published",
        "alternateNames"=> [
            "The Adventures of Batman and Robin"
        ],
        "shortDescription"=> "A moody Caped Crusader defends Gotham City against the usual suspects in this animated series inspired by director Tim Burton's dark theatrical films. The show was renamed The Adventures of Batman and Robin for its final year and yielded a movie, Batman: Mask of the Phantasm."
      }
    }.to_json
  end

  def season(show_id)
    {
      "metadata"=> {
        "slug"=> "batman-the-animated-series-season-1",
        "show"=> {
            "showId"=> show_id
        },
        "order"=> 1
      }
    }.to_json
  end

  def tv_release(season_id)
    {
      "metadata"=> {
        "name"=> "Batman: The Animated Series: Season 1",
        "state"=> "published",
        "commonName"=> "Season 1",
        "season"=> {
            "seasonId"=> season_id
        }
      }
    }.to_json
  end

  def volume
    {
        "metadata"=> {
            "slug"=> "batman-the-dark-knight-vol-2",
            "legacyId"=> 110600,
            "name"=> "Batman: The Dark Knight Vol. 2",
            "type"=> "comic",
            "state"=> "published",
            "commonName"=> "Batman: The Dark Knight",
            "misspelledNames"=> [
                "The Dark Knight Vol. 2",
                "The Dark Knight",
                "Batman The Dark Knight"
            ],
            "description"=> "The Dark Knight struggles against a deadly - yet strangely familiar - foe in this phenomenal debut issue from superstar writer/artist David Finch (Brightest Day, Action Comics)!

As a mysterious figure slinks through the halls of Arkham Asylum, Batman must fight his way through a gauntlet of psychos, and Bruce Wayne faces the unexpected legal ramifications of Batman Incorporated!",
            "shortDescription"=> "The Dark Knight struggles against a deadly - yet strangely familiar - foe in this phenomenal debut issue from superstar writer/artist David Finch (Brightest Day, Action Comics)!"
        }
    }.to_json
  end

  def book(volume_id)
    {
        "metadata"=> {
            "slug"=> "batman-the-dark-knight-2011-11",
            "legacyId"=> 138260,
            "order"=> 11,
            "volume"=> {
                "volumeId"=> volume_id
            }
        }
    }.to_json
  end

  def comic_company
    {
        "metadata"=> {
            "slug"=> "dc-comics",
            "legacyId"=> 734474,
            "name"=> "DC Comics"
        }
    }.to_json
  end

  def comic_release(book_id, co_id)
    {
        "metadata"=> {
            "legacyId"=> 138260,
            "name"=> "Batman: The Dark Knight Vol. 2 #11",
            "commonName"=> "Batman: The Dark Knight #11",
            "state"=> "published",
            "shortDescription"=> "Scarecrow makes a bold move against Batman, using Commissioner Gordan as bait! The terrifying pasts of both Scarecrow and Batman come back to haunt them.",
            "description"=> "Scarecrow makes a bold move against Batman, using Commissioner Gordan as bait! The terrifying pasts of both Scarecrow and Batman come back to haunt them.",
            "releaseDate"=> {
                "date"=> "2012-07-25"
            },
            "misspelledNames"=> [
                "The Dark Knight Vol. 2 #11",
                "The Dark Knight #11",
                "Batman The Dark Knight #11"
            ],
            "book"=> {
                "bookId"=> book_id
            }
        },
        "content"=> {
            "mediaType"=> "print"
        },
        "companies"=> {
            "publishers"=> [
                {
                    "companyId"=> co_id
                }
            ]
        },
        "legacyData"=> {
            "boxArt"=> [
                {
                    "url"=> "http://comicsmedia.ign.com/comics/image/object/138/138260/batman-the-dark-knight-11_cover-artboxart_160w.jpg",
                    "height"=> 242,
                    "width"=> 160,
                    "positionId"=> 5
                }
            ]
        }
    }.to_json
  end

end