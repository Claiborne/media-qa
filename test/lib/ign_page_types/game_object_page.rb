require 'page'

module Oyster
 module IGN
  class GameObjectPage < Page

    def initialize(client,config)
      super(client,config)
    end

    def is_following?
      flag = true

      attribute_str = @client.get_attribute("css=div#container-title div.addToIGNContainer div.addToIGN@style")
      if attribute_str.include?("follow_")
        flag = false
      end
      flag
    end

    def start_following_game
      # TODO add is_element_present logic
      if !self.is_following?
        @client.click "css=div#container-title div.addToIGNContainer  div.addToIGN"
      else
        puts "already following the game"
      end
    end

    def stop_following_game
      # TODO add is_element_present logic
      if self.is_following?
        @client.click "css=div#container-title div.addToIGNContainer  div.addToIGN"
        @client.click "css=div#container-title div.addToIGNContainer div.removeFromIGN"
      else
        puts "not following the game in the first place"
      end
    end

   def manage_game
     @client.click "css=div#container-title div.addToIGNContainer  div.addToIGN"
     @client.click "css=div#container-title div.addToIGNContainer div.manageStuff a", :wait_for => :page
     @client.wait_for_page_to_load
   end
   
  end
 end
end