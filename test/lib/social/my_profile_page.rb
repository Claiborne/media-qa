require 'ign_site_mod'
require 'page'

module Oyster
module Social
class MyProfilePage < Page

  include IGNSiteMod	

  def visit(url="http://#{@config.options['baseurl_myign_people']}/", user_name)
    open(url+user_name.to_s)
  end

  def create_new_psn_gamercard
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
    
	@client.click "NewIdBtn"
    @client.click "slctone"
    @client.type "css=li#Editrow input.platformId", "battlenetcard"
    @client.click "battlenet"
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
  
    def initialize(client,config)
      super(client,config)
    end

    def is_following?
      flag = true
      
      attribute_str = @client.get_attribute("css=div.socialProfileHeader div.addToIGN@style")
      if attribute_str.include?("follow_")
        flag = false
      end
      flag
    end

    def start_following_person
      # TODO add is_element_present logic
      if !self.is_following?
        @client.click "css=div.socialProfileHeader div.profileInfo div[id^='myIgnFollowPerson'] div.addToIGNContainer div.addToIGN"
      else
        puts "already following this person"
      end
    end

    def stop_following_person
      # TODO add is_element_present logic
      if self.is_following?
        @client.click "css=div.socialProfileHeader div.profileInfo div[id^='myIgnFollowPerson'] div.addToIGNContainer div.addToIGN"
        @client.click "css=div.socialProfileHeader div[id^='myIgnFollowPerson'] div.removeFromIGN"
      else
        puts "not following this person in the first place"
      end
    end

    def is_wall_post_entry_available?
      flag = @client.is_element_present("css=div#updateStatusContainer input#statusField")
      flag
    end

    def submit_wall_post
      if self.is_wall_post_entry_available?
        #TODO enter text and click add button
      end
    end

    def initialize(client,config)
      super(client,config)
    end

  def is_following?
      flag = true
      
      attribute_str = @client.get_attribute("css=div.socialProfileHeader div.addToIGN@style")
      if attribute_str.include?("follow_")
        flag = false
      end
      flag
  end
    
  def start_following_person
      # TODO add is_element_present logic
      if !self.is_following?
        @client.click "css=div.socialProfileHeader div.profileInfo div[id^='myIgnFollowPerson'] div.addToIGNContainer div.addToIGN"
      else
        puts "already following this person"
      end 
  end

  def stop_following_person
      # TODO add is_element_present logic
      if self.is_following?
        @client.click "css=div.socialProfileHeader div.profileInfo div[id^='myIgnFollowPerson'] div.addToIGNContainer div.addToIGN"
        @client.click "css=div.socialProfileHeader div[id^='myIgnFollowPerson'] div.removeFromIGN"
      else
        puts "not following this person in the first place"
      end
  end

  def is_wall_post_entry_available?
      flag = @client.is_element_present("css=div#updateStatusContainer input#statusField")
      flag
  end

  def submit_wall_post
      if self.is_wall_post_entry_available?
        #TODO enter text and click add button
      end
  end
end
end
end