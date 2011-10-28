module LinkChecker
  
  def check_for_broken_links(locator)
    @doc.css("#{locator} a[href*='http']").each do |a|
      link = a.attribute('href').to_s
      response = rest_client_open link
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end
  
  def check_for_broken_images(locator)
    @doc.css("#{locator} img[src*='http']").each do |img|
      img_src = img.attribute('src').to_s
      response = rest_client_open img_src
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
    end
  end
  
  def check_links_200(locator)
    @doc.css("#{locator} a[href*='http']").each do |a|
      link = a.attribute('href').to_s
      response = rest_client_open link
      response.code.should_not eql(/4\d\d/)
      response.code.should_not eql(/5\d\d/)
      response.code.should_not eql(/3\d\d/)
      response.code.should eql(200)
    end
  end
  
end

