module OpenPage

def nokogiri_open(page)
  stitial_count = 0
  nok_doc = Nokogiri::HTML(open(page))
  while nok_doc.at_css('div#disable')
    nok_doc = Nokogiri::HTML(open(page))
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      nok_doc = Nokogiri::HTML(open(page+"?special=noads"))
    end
  end#end while
  return nok_doc
end#end def

def rest_client_open(page)
  puts page ########
  stitial_count = 0
  ############
  begin
  rest_doc = RestClient.get(page)
  rescue => e
  raise Exception.new("#{e.http_code} Error on page without encountering a stitial: "+page.to_s)
  end
  ############
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    ############
    begin
    rest_doc = RestClient.get(page)
    rescue => e
    raise Exception.new("#{e.http_code} Error on page WITH encountering a stitial: "+page.to_s)
    end
    ############
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      ############
      begin
      rest_doc = RestClient.get(page+"?special=noads")
    rescue => e
    raise Exception.new("#{e.http_code} Error on page with special=stital: "+page.to_s)
      end
      ############
    end
  end#end while
  return rest_doc
end

end