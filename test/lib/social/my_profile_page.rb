require 'ign_site'
require 'ign_site_mod'

module Oyster
module Social
class MyProfilePage < IGNSite

  include IGNSiteMod

  def create_new_psn_gamercard
  	#open "http://#{@baseurl_people}/#{@username_val}"
	open "http://#{@config.options['baseurl_myign_people']}/clay.ign"
	@client.click "NewIdBtn"    
	@client.type "css=li#Editrow input.platformId", "psngamercard"
    @client.click "slctone"
    @client.click "psn"
    @client.click "SaveIdBtn"
    7.times do
      refresh
      if @client.get_text("css=ul#activityList").match(/gameID/)
        return true
      end
    end
    return false
  end
  
  def create_four_gamer_cards
	@client.click "NewIdBtn"    
	@client.type "css=li#Editrow input.platformId", "xboxgamercard"
    @client.click "slctone"
    @client.click "xbox"
    @client.click "SaveIdBtn"
    refresh
  
	@client.click "NewIdBtn"
    @client.click "slctone"   
    @client.type "css=li#Editrow input.platformId", "wiigamercard"
    @client.click "wii"
    @client.click "SaveIdBtn"
    refresh

	@client.click "NewIdBtn"
    @client.type "css=li#Editrow input.platformId", "3dsgamercard"
    @client.click "slctone"
    @client.click "n3ds"
    @client.click "SaveIdBtn"
    refresh

	@client.click "NewIdBtn"
    @client.click "slctone"
    @client.type "css=li#Editrow input.platformId", "steamgamercard"
    @client.click "steam"
    @client.click "SaveIdBtn"
    
    7.times do
      refresh
      if @client.is_visible("css=li#pagination")
        return true
      end
    end
    return false
  end
  
  def edit_gamer_card
  	@client.click "css=ul.gamerids span.editlinks" 
  	@client.type "css=input#remoteEditName", "hello"
    @client.click "SaveIdBtn"
    
    7.times do
      refresh  	
      if @client.get_text("css=ul.gamerids li").match(/hello/)
        return true
      end
    end
    return false
  end
  
  def delete_a_gamercard
	card_name = @client.get_text("css=ul.gamerids li")
	@client.click "css=ul.gamerids span.editlinks" 
	@client.click "css=div#DeleteIdBtn"
	3.times do
	  if @client.get_text("css=ul.gamerids li") != card_name 
	    return true
	  end
	  sleep 1 
	end
	return false
  end
  
end
end
end