module OpenPage

def nokogiri_open(page)
  stitial_count = 0
  nok_doc = Nokogiri::HTML(open(page))
  sleep 1
  while nok_doc.at_css('div#disable')
    nok_doc = Nokogiri::HTML(open(page))
    sleep 1
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
  stitial_count = 0
  begin
    rest_doc = RestClient.get(page)
  rescue => e
    raise Exception.new("#{e.http_code} error on: "+page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = RestClient.get(page)
    rescue => e
      raise Exception.new("#{e.http_code} error on (after skipping a stitial): "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = RestClient.get(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.http_code} error on page (with special=stital): "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

end