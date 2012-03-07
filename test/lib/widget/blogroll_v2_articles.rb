module Blogrollv2Articles

  require 'fe_checker'
  include FeChecker

  def check_is_not_blank(doc, num, element)
    i = 0
    doc.css(element).each do |element_instance|
      if element_instance.text.delete("^a-zA-Z").length <  1
        i = i+1
      end
    end
    doc.css(element).count.should > 0
    i.should be < num*0.7
  end
  
  def widget_blogroll_v2_articles_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.blogrollv2Container').should be_true
    end
  end
  
  def widget_blogroll_v2_articles(num, call)
    
    widget_blogroll_v2_articles_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.blogrollv2Container').count.should == 1
    end
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.blogrollv2Container').should be_true
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.blogrollv2Container')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.blogrollv2Container')
    end
    
    if call.match(/&tags=tech,wii-u&/)
      it "should have #{num} blogroll entries"
    else
      it "should have #{num} blogroll entries", :smoke => true do
        @doc.css('div.blogrollv2Container div.listElmnt').count.should eql(num)
      end
    end

    it "shoud display the author's name / timestamp" do
      check_is_not_blank(@doc, num, "div.blogrollv2Container span.listElmnt-date")
    end

    it "shoud display the articles' headlines", :smoke => true do
      check_is_not_blank(@doc, num, "div.blogrollv2Container h3 a.listElmnt-storyHeadline")
    end

    it "shoud display articles' summaries", :smoke => true do 
      i = 0
      @doc.css("div.blogrollv2Container div.listElmnt-blogItem p").count.should > 0
      @doc.css("div.blogrollv2Container div.listElmnt-blogItem p").each do |summary|
        article_byline = summary.css('span').text
        article_read_more = summary.css('a').text
        if summary.text.gsub(article_byline,"").gsub(article_read_more,"").delete("^a-zA-Z").length < 1
          i = i+1
        end
      end
      i.should be < num*0.7
    end
    
    it "shoud display the read more links" do
      check_is_not_blank(@doc, num, "div.blogrollv2Container a.moreLink")
    end

    it "should display only unique entries", :smoke => true do  
      headline = []
      @doc.css('div.listElmnt-blogItem a.listElmnt-storyHeadline').should be_true
      @doc.css('div.listElmnt-blogItem a.listElmnt-storyHeadline').each do |entry|
        headline << entry.attribute('href')
      end
      headline.count.should > 0
      headline.count.should eql(headline.uniq.count)
    end
    
    it "should contain first two headline links that return 200", :spam => true do
      @doc.at_css("div.blogrollv2Container div:nth-child(1).listElmnt h3 a").should be_true
      link = @doc.at_css("div.blogrollv2Container div:nth-child(1).listElmnt h3 a").attribute("href").to_s
      response = rest_client_not_301_home_open link
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
      response.code.should eql(200)

      link = @doc.at_css("div.blogrollv2Container div:nth-child(2).listElmnt h3 a").attribute("href").to_s
      response = rest_client_not_301_home_open link
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
      response.code.should eql(200)
    end

    it "should display the same articles as the api returns" do
      Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
      config = Configuration.new
    
      data = JSON.parse((rest_client_open("http://#{config.options['baseurl']}#{call}")).body)
      api_titles = []
      data.each do |article|
        api_titles << article['blogroll']['headline'].gsub(/&rsquo;/,"").delete("^a-zA-Z")
      end

      frontend_titles = []
      @doc.css("div.blogrollv2Container h3 a.listElmnt-storyHeadline").each do |article|
        frontend_titles << article.text.gsub(/&rsquo;/,"").delete("^a-zA-Z")
      end
      titles = api_titles + frontend_titles
      titles.uniq.count.should be <= num+2
      # Debug code
      api_titles.each do |i|
        puts i
      end
      puts ""
      frontend_titles.each do |i|
        puts i
      end
    end

  end
end