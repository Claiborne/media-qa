require 'page'

module Oyster
 module Social
  class MyProfilePage < Page

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