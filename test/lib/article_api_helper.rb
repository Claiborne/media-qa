class ArticleAPIHelper

  def self.min_article_create
    {
      :metadata => {
        :headline =>"Media QA Test Article #{Random.rand(100000-999999)}",
        :articleType =>"article",
        :state =>"published"
      },
      :authors => [
        {
          :name =>"Media-QA"
        }
      ],
      :content => ["Test Content Body. Media QA Test Article..."]
    }.to_json
  end

  def self.publish
    {
      :metadata => {
        :state => 'published'
      }
    }.to_json
  end

  def self.new_review_article(num)
    {
      :metadata => {
        :headline =>"Media QA Test Review Article #{num}",
        :articleType =>"article",
        :state =>"draft",
        :headerVideoUrl => "http://www.ign.com/videos/2012/02/09/call-of-duty-modern-warfare-3-commentary",
        :headerImageUrl => "http://oyster.ignimgs.com/wordpress/stg.ign.com/2011/11/test.jpg"
      },
      :authors => [
        {
          :name =>"Media-QA"
        }
      ],
      :content => ["Test Content Body. Media QA Test Article..."],
      :review => {
        :highlights => [
        "highlight summary 1",
        "highlight summary 2"
        ],
        :blurb => "a short blurb",
        :score => 9.5,
        :comment => "comments",
        :breakdown => [
          {
          :name => "Gameplay",
          :score => 9.0,
          :comment => "comments"
          },
          {
          :name => "Presentation",
          :score => 9.0,
          :comment => "comments"
          }
        ],
        :pros => %w(graphics sound),
        :nominations => %w(nom1 nom2),
        :cons =>  %w(story voice),
        :editorsChoice => true
      },
      :sideBars => [
        {
        :headline => "side headline 1",
        :summary => "side content 1"
        },
        {
        :headline => "side headline 2",
        :summary => "side content 2"
        }
      ],
      :legacyData => {
        :objectRelations => [111122],
        :relatedWorks => [61088, 83607]
      },
      :relatedWorks => {:headline => 'related works headline'}
    }.to_json
  end

  def self.changed_review_article
    {
        :metadata => {
            :state =>"published", # changed value
        },
        :review => {
            :highlights => [
                "highlight summary 1",
                "highlight summary 2",
                "added" # added
            ],
            :blurb => "a short blurb changed", #changed string
            :breakdown => [
                {
                    :name => "Gameplay",
                    :score => 9.0,
                    :comment => "comments"
                },
                {
                    :name => "Presentation",
                    :score => 9.0,
                    :comment => "comments"
                },
                {
                  :name => "Sound", # added field
                  :score => 8.5, # added field
                  :comment => "comments" # added field
                }

            ],
            :pros => %w(graphics sound added), # added value
            :nominations => %w(nom1 nom2 added), # added value
        },
        :sideBars => [
            {
                :headline => "changed", #changed value
                :summary => "side content 1"
            },
            {
                :headline => "side headline 2",    #added field
                :summary => "side content 2"       #added field
            }
        ],
        :legacyData => {
            :relatedWorks => [61088, 83607, 122888] # added value
        },
        :relatedWorks => {:headline => 'related works headline changed'} #changed string
    }.to_json
  end

  def self.get_articles_by_state(state)
    {"matchRule"=>"matchAll",
     "count"=>50,
     "startIndex"=>0,
     "states"=>state,
     "rules"=>[
     ],
    }.to_json
  end

end