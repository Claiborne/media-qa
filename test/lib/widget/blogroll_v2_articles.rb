module Blogrollv2Articles
#spec file requires Nokogiri, rspec, rest_client, and json

  def check_not_blank(doc, num, element)
    i = 0
    doc.css(element).each do |element_instance|
      if element_instance.text.length < 5
        i = i+1
      end
    end
    i.should be < num
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
  
  def widget_blogroll_v2_articles_check_comments_link(doc, num_of_entries)
    check_not_blank(doc, num_of_entries, "div#ign-blogroll a.listElmnt-iconsComments")
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
    titles = titles.uniq
    titles.count.should be <= num+2
  end
  
end