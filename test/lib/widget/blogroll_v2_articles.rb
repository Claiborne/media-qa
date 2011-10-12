module Blogrollv2Articles
#spec file requires Nokogiri, rspec, rest_client, and json

  def check_not_blank(doc, num, element)
    i = 0
    doc.css(element).each do |element_instance|
      if element_instance.text.delete("^a-zA-Z").length <  1
        i = i+1
      end
    end
    doc.css(element).count.should > 0
    i.should be < num*0.7
  end
  
  def widget_blogroll_v2_articles_check_not_missing(doc)
    doc.at_css('div#ign-blogroll').should be_true
  end
  
  def widget_blogroll_v2_articles_check_num_entries(doc, num_of_entries)
    doc.css('div#ign-blogroll div.listElmnt-articleContent').count.should eql(num_of_entries)
  end

  def widget_blogroll_v2_articles_check_author_name(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll div.listElmnt-authors")
  end
  
  def widget_blogroll_v2_articles_check_timestamp(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll div.listElmnt-date")
  end
  
  def widget_blogroll_v2_articles_check_headline(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll a.listElmnt-storyHeadline")
  end
  
  def widget_blogroll_v2_articles_check_article_summary(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll p.listElmnt-summary")
  end
  
  def widget_blogroll_v2_articles_check_read_more(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll a.moreLink")
  end
  
  def widget_blogroll_v2_articles_check_matches_article_api(doc, num, api)
    data = JSON.parse((RestClient.get api).body)
    api_titles = []
    data.each do |article|
      api_titles << article['blogroll']['headline']
    end
    
    frontend_titles = []
    doc.css("div#ign-blogroll a.listElmnt-storyHeadline").each do |article|
      frontend_titles << article.text
    end
    titles = api_titles + frontend_titles
    titles.uniq.count.should be <= num+3
  end
  
  def widget_blogroll_v2_articles_check_no_duplicates(doc)
    headline = []
    doc.css('div.listElmnt-articleContent a.listElmnt-storyHeadline').each do |entry|
      headline << entry.attribute('href')
    end
    headline.count.should > 0
    headline.count.should eql(headline.uniq.count)
  end
  
  def widget_blogroll_v2_articles(num, call)

    it "should not be missing from the page", :stg => true do
      widget_blogroll_v2_articles_check_not_missing(@doc)
    end
  
    it "should have #{num} blogroll entries", :stg => true do
      widget_blogroll_v2_articles_check_num_entries(@doc, num)
    end

    it "shoud display author name", :stg => true do
      widget_blogroll_v2_articles_check_author_name(@doc, num)
    end
    
    it "shoud display timestamp", :stg => true do
      widget_blogroll_v2_articles_check_timestamp(@doc, num)
    end

    it "shoud display headline", :stg => true do
      widget_blogroll_v2_articles_check_headline(@doc, num)
    end

    it "shoud display article summary", :stg => true do
      widget_blogroll_v2_articles_check_article_summary(@doc, num)
    end
    
    it "shoud display read more link in article summary", :stg => true do
      widget_blogroll_v2_articles_check_read_more(@doc, num)
    end

    it "should display only unique entries", :stg => true do
      widget_blogroll_v2_articles_check_no_duplicates(@doc)
    end

    it "should display the same articles as the api returns", :stg => true do
      Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
      config = Configuration.new
    
      widget_blogroll_v2_articles_check_matches_article_api(@doc, num, "http://#{config.options['baseurl']}#{call}")
    end

  end
end