require 'page'
require 'ign_site_mod'

module Oyster
module Social
class MyGamesPage < Page
 
  include IGNSiteMod
 
  def visit(url="http://#{@config.options['baseurl_myign']}/games")
    open(url)
  end
  
end
end
end