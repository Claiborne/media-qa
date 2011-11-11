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
  stitial_count = 0
  puts "opening page normally"+stitial_count.to_s
  rest_doc = RestClient.get(page)
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    puts "opening page after stitial"+stitial_count.to_s
    rest_doc = RestClient.get(page)
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      puts "opening page with special=noads"+stitial_count.to_s
      rest_doc = RestClient.get(page+"?special=noads")
    end
  end#end while
  return rest_doc
end

end