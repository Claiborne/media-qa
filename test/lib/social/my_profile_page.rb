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

    def is_user_activity_posted?(msg)
      txt = @client.get_text("css=div.activityBody")

      flag = txt.include?(msg)
      flag
    end

    def delete_user_activity_entry(msg)
      if self.is_user_activity_posted?(msg)
        max = @client.get_xpath_count("//li[contains(@class,'activity')]").to_i
        puts max
        (1..max).each{ |i|
          txt = @client.get_text("css=li.activity:nth-child(#{i})")
          if txt.include?(msg)
            @client.click "css=li.activity:nth-child(#{i}) > div.activityBody > span.deleteMe"
            break
          end
        }
      end
    end

  end
 end
end