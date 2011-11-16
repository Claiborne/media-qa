module OpenPage

def nokogiri_open(page)
  stitial_count = 0 
  begin
    nok_doc = Nokogiri::HTML(open(page))
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s )
  end#end Exception
  while nok_doc.at_css('div#disable')
    begin
      nok_doc = Nokogiri::HTML(open(page))
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s )
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise Exception.new("An endless stitial loop on #{page} prevented this test case from running")
    elsif stitial_count > 2
      begin
        nok_doc = Nokogiri::HTML(open(page+"?special=noads"))
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return nok_doc
end#end def

def rest_client_open(page)
  stitial_count = 0
  begin
    rest_doc = RestClient.get(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s+" "+e.http_body+" "+e.inspect)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = RestClient.get(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = RestClient.get(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

end