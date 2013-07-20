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
  
  # This method assumes max is 20
  def self.enforce_max_contains(contains)
    {
    :matchRule=>"matchAll",
    :rules=>[
      {
         :field=>"metadata.articleType",
         :condition=>"is",
         :value=>"post"
      },
      {
         :field=>"tags.slug",
         :condition=>contains,
         :value=>"zz1,zz2,zz3,zz4,zz5,zz6,zz7,zz8,zz9,zz10,zz11,zz12,zz13,zz14,zz15,zz16,zz17,zz18,zz19,ps3,xbox-360"
      }
    ],
    :startIndex=>0,
    :count=>200,
    :networks=>"ign",
    :states=>"published",
    :fields=>["metadata.headline","metadata.publishDate","tags.slug"]
  }.to_json  
  end

end #end ArticleAPIHelper

shared_examples "basic article API checks" do |count|

  it "should return a hash with five indices" do
    check_indices(@data, 6)
  end

  it "should return 'count' data with a non-nil, non-blank value" do
    @data.has_key?('count').should be_true
    @data['count'].should_not be_nil
    @data['count'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'count' data with a value of #{count}" do
    @data['count'].should == count
  end

  it "should return 'startIndex' data with a non-nil, non-blank value" do
    @data.has_key?('startIndex').should be_true
    @data['startIndex'].should_not be_nil
    @data['startIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'startIndex' data with a value of 0" do
    @data['startIndex'].should == 0
  end

  it "should return 'endIndex' data with a non-nil, non-blank value" do
    @data.has_key?('endIndex').should be_true
    @data['endIndex'].should_not be_nil
    @data['endIndex'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'endIndex' data with a value of #{count-1}" do
    @data['endIndex'].should == count-1
  end

  it "should return 'isMore' data with a non-nil, non-blank value" do
    @data.has_key?('isMore').should be_true
    @data['isMore'].should_not be_nil
    @data['isMore'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'isMore' data with a value of true" do
    @data['isMore'].should == true
  end

  it "should return 'total' data with a non-nil, non-blank value" do
    @data.has_key?('total').should be_true
    @data['total'].should_not be_nil
    @data['total'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'total' data with a value greater than 20" do
    @data['total'].should > 20
  end

  it "should return 'data' with a non-nil, non-blank value" do
    @data.has_key?('data').should be_true
    @data['data'].should_not be_nil
    @data['data'].to_s.delete("^a-zA-Z0-9").length.should > 0
  end

  it "should return 'data' with an array length of #{count}" do
    @data['data'].length.should == count
  end

  it "should return 'networks' metadata with a value that includes 'ign' for all articles" do
    @data['data'].each do |article|
      article['metadata']['networks'].include?('ign').should be_true
    end
  end

  it "should return 'state' metadata with a value of 'published' for all articles" do
    @data['data'].each do |article|
      article['metadata']['state'].should == 'published'
    end
  end

  it "should return articles in descending 'publishDate' order" do
    pub_date_array = []
    @data['data'].each do |article|
      article['metadata']['publishDate'].should_not be_nil
      pub_date_array << Time.parse(article['metadata']['publishDate'])
    end
    pub_date_array.should == (pub_date_array.sort {|x,y| y <=> x })
  end

  it "should return non-nil, non-blank 'articleId' data for all articles" do
    @data['data'].each do |article|
      article['articleId'].should_not be_nil
      article['articleId'].to_s.delete("^a-zA-Z0-9").length.should > 0
    end
  end

  it "should return an articleId with a 24-character hash value for all articles" do
    @data['data'].each do |article|
      article['articleId'].match(/^[0-9a-f]{24,32}$/).should be_true
    end
  end

  [ "articleId",
    "metadata",
    "system",
    "tags",
    "refs",
    "authors",
    "categoryLocales",
    "categories",
    "content"].each do |k|
    it "should return non-nil '#{k}' data for all articles" do
      @data['data'].each do |article|
        article.has_key?(k).should be_true
        article.should_not be_nil
        article.to_s.length.should > 0
      end
    end
  end#end iteration

end