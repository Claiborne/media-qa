require 'page'
require 'ign_site_mod'

module Oyster
module Social
class MyGamesPage < Page
 
  include IGNSiteMod
 
  def visit(url="http://#{@config.options['baseurl_myign']}/games")
    open(url)
  end
  
  def rate_a_game
  	@client.click "css=div.ratingDisplay span.rateMe"
  	5.times do
  	  if @client.is_visible "css=div[id*='gameRatingOverlay']"
  	    break
  	  else
  	    sleep 1
  	  end
  	end
  	
  	if @client.is_visible "css=div[id*='gameRatingOverlay']"
  	  @client.click "css=div.ratingEnryLight input"
  	  rating = rand(0-10).to_s
  	  @client.type "css=div.ratingEnryLight input", rating
  	  @client.click "css=div[id*='gameRatingSubmit']"
  	else
  	  return false
  	end
  	
  	5.times do
  	  if @client.get_text("css=span[id*='myRatingNumber']") == rating
  	    return true
  	  else
  	    sleep 1
  	  end
  	end
  	return false
  end
  
end
end
end