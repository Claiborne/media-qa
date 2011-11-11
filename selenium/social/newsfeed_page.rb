require 'page'

module Oyster
 module Social
  class NewsfeedPage < Page

    def initialize(client,config)
      super(client,config)
    end

    def submit_post(msg)
      @client.type "css=input#statusField", msg
      @client.click "css=div#btnUpdateStatus", :wait_for => :text, :element => "css=ul#activityList", :text => /#{msg}/, :timeout_in_seconds => 30
    end

    def is_user_activity_posted?(msg)
      txt = @client.get_text("css=div.activityBody")
      
      flag = txt.include?(msg)
      flag
    end

    def is_entry_deletable?
      flag = false
      beg_index = 'activityRow'.length
      if self.is_user_activity_posted?(msg)
        max = @client.get_xpath_count("//li[contains(@class,'activity')]").to_i

        (1..max).each{ |i|
          txt = @client.get_text("css=li.activity:nth-child(#{i})")


          if txt.include?(msg)
            attribute = @client.get_attribute("css=li.activity:nth-child(#{i})@id")
            puts attribute
            activityId = attribute[beg_index,attribute.length]
            flag = @client.is_element_present "css=li##{attribute} span#delete#{activityId}"
            #@client.click "css=ul#activityList li:nth-child(#{i}) > div.activityBody > span.deleteMe"
            break
          end
        }
      
      end
      flag
    end

    def delete_user_activity_entry(msg)
      beg_index = 'activityRow'.length
      if self.is_user_activity_posted?(msg)
        max = @client.get_xpath_count("//li[contains(@class,'activity')]").to_i
        
        (1..max).each{ |i|          
          txt = @client.get_text("css=li.activity:nth-child(#{i})")
          
          
          if txt.include?(msg)
            attribute = @client.get_attribute("css=li.activity:nth-child(#{i})@id")
            puts attribute
            activityId = attribute[beg_index,attribute.length]
            @client.click "css=li##{attribute} span#delete#{activityId}"
            #@client.click "css=ul#activityList li:nth-child(#{i}) > div.activityBody > span.deleteMe"
            break
          end
        }
      end
    end
  end
 end
end