require 'nokogiri'
require 'rest_client'

# EXAMPLE HOW TO RUN

# rake checklinks css='div div.topgames-module' url='www.ign.com/games/reviews/xbox-360'

puts ""
puts "BROKEN LINKS:"

@doc = Nokogiri::HTML(RestClient.get(ENV['url']))

puts "(checking #{@doc.css("#{ENV['css']} a").count}) links"

@doc.css("#{ENV['css']} a").each do |a|

  link = a.attribute('href').to_s

  begin
    RestClient.get link
  rescue
    puts link.to_s
  end

end

puts ""


