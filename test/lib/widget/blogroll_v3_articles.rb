module Blogrollv3Articles

  require 'fe_checker'
  require 'rest_client'
  require 'json'
  include FeChecker
  
  def widget_blogroll_v3_articles_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.blogrollContainer').should be_true
    end
  end
  
  def widget_blogroll_v3_articles_nav(nav)
    
    if ['platform','article'].include?(nav)
      
      it "should display the #{nav} nav once", :smoke => true do
        @doc.css('div.blogrollContainer ul.ign-blogrollFilters').count.should == 1
      end
      
      it "should display at least two li in the #{nav} nav", :smoke => true do
        @doc.css('div.blogrollContainer ul.ign-blogrollFilters li').count.should > 1
      end
      
      it "should display text for each li in the #{nav} nav", :smoke => true do
        check_display_text_for_each('div.blogrollContainer ul.ign-blogrollFilters li')
      end
      
      it "should have a link for each li in the #{nav} nav", :smoke => true do
        check_have_a_link_for_each('div.blogrollContainer ul.ign-blogrollFilters li')
      end
      
    end#end if
    
    case nav
      when 'platform'
        it "should be display at least 'PS3' in the #{nav} nav", :smoke => true do
           @doc.css('div.blogrollContainer ul.ign-blogrollFilters').text.match('PS3').should be_true
        end
        
        ['All', 'Xbox 360', 'PS3', "Wii U", "PS Vita", "PC", "3DS", "iPhone/Android"].each do |plat|
          it "should display a link to #{plat} in the nav" do
            @doc.css('div.blogrollContainer ul.ign-blogrollFilters').text.match(plat).should be_true
          end
        end
        
      when 'article'
        it "should be display at least 'Reviews' in the #{nav} nav", :smoke => true do
           @doc.css('div.blogrollContainer ul.ign-blogrollFilters').text.match('Review').should be_true
        end
    end#end case
  end#end widget_blogroll_v3_articles_nav(nav)
  
  def widget_blogroll_v3_articles(num, nav)
    
    widget_blogroll_v3_articles_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.blogrollContainer').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.blogrollContainer')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.blogrollContainer')
    end
    
    it "should have at least 10 blogroll entires", :smoke => true do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem').count.should > 9
    end
    
    it "should have at least 10 blogroll headlines", :smoke => true do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem h3').count.should > 9
    end
    
    it "should have at least 10 blogroll headline article links", :smoke => true do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem h3 a').count.should > 9
    end
    
    it "should have at least 10 blogroll previews", :smoke => true do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem p').count.should > 9
    end
    
    it "should have at least 10 blogroll timestamps" do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem span.listElmnt-date').count.should > 9
    end
    
    it "should display text for each blogroll entry", :smoke => true do
      check_display_text_for_each('div.blogrollContainer div.listElmnt-blogItem')
    end
    
    it "should have at least one link for each blogroll entry", :smoke => true do
      check_have_a_link_for_each('div.blogrollContainer div.listElmnt-blogItem')
    end
    
    it "should display text for each blogroll headline", :smoke => true do
      check_display_text_for_each('div.blogrollContainer div.listElmnt-blogItem h3')
    end
    
    it "should have a least one link for each blogroll headline", :smoke => true do
      check_have_a_link_for_each('div.blogrollContainer div.listElmnt-blogItem h3')
    end
    
    it "should display text for each blogroll preview", :smoke => true do
      @doc.css('div.blogrollContainer div.listElmnt-blogItem p').each do |preview|
        preview.text.gsub(preview.css('span').text, "").delete("^a-zA-Z").length.should > 0
      end
    end
    
    it "should display text for each blogroll timestamp" do
      check_display_text_for_each('div.blogrollContainer div.listElmnt-blogItem span.listElmnt-date')
    end
    
    it "should not display duplicate articles", :smoke => true do
      v3_blogroll_article_list = []
      @doc.css('div.blogrollContainer div.listElmnt-blogItem h3 a').each do |article|
        v3_blogroll_article_list << article.attribute('href').to_s
      end
      begin
        v3_blogroll_article_list.length.should == v3_blogroll_article_list.uniq.length
      rescue => e
        v3_blogroll_article_list_well_formed=""
        v3_blogroll_article_list.each do |article|
          v3_blogroll_article_list_well_formed << article.to_s+"\n"
        end
        raise Exception.new("#{e.message}. The following articles appeared in the blogroll:\n"+v3_blogroll_article_list_well_formed)
      end#end Exception
    end
    
    it "should display the 'load more' button once", :smoke => true do
      @doc.css('div.blogrollContainer button#loadMore').count.should == 1
    end
    
    widget_blogroll_v3_articles_nav(nav)
    
  end

  def widget_blogroll_v3_articles_vs_api(count, category, locale)
    
    it "should display the same articles as the API returns" 
=begin
      # Get articles from API
      api_call = 
      {"matchRule"=>"matchAll",
       "count"=>count.to_i,
       "startIndex"=>0,
       "networks"=>"ign",
       "states"=>"published",
       "rules"=>[
         {"field"=>"metadata.articleType",
           "condition"=>"is",
           "value"=>"article"},
         {"field"=>"categories.slug",
          "condition"=>"contains",
          "value"=>"#{category}"},
         {"field"=>"categoryLocales",
          "condition"=>"contains",
          "value"=>"#{locale}"}
          ],
        "sortBy"=>"metadata.publishDate",
        "sortOrder"=>"desc"
      }.to_json
      api_response = RestClient.post "http://apis.lan.ign.com/article/v3/articles/search", api_call, :content_type => "application/json"
      api_articles = JSON.parse(api_response.body)
      api_article_headlines = []
      api_articles['data'].each do |api_article|
        api_article_headlines << api_article['promo']['title']
      end
      
      # Get articles from v3_blogroll
      blogroll_headlines = []
      @doc.css('div.blogrollContainer div.listElmnt-blogItem h3').each do |blogroll_article|
       blogroll_headlines << blogroll_article.text
      end
      
      # Compare headlines from API and Blogroll
      begin
        api_article_headlines.should == blogroll_headlines
      rescue => e
        raise Exception.new("#{e.message}\nAPI returned: #{api_article_headlines}\nBlogroll returned: #{blogroll_headlines}")
      end#end Exception
 
    end#end it
=end 
  end#end def

end#end module