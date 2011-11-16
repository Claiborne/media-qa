module FeSmokeChecker
  
  def should_display_text(locator)
    @doc.css(locator).text.delete("^a-zA-Z").length.should > 0
  end
  
  def should_have_a_link(locator)
    @doc.css("#{locator} a").count.should > 0
    @doc.css("#{locator} a[href*='http']").count.should > 0
  end
  
  def should_have_an_img(locator)
    @doc.css("#{locator} img").count.should > 0
    @doc.css("#{locator} img[src*='http']").count.should > 0
  end
  
end
  

