require 'page'

module Oyster
 module Social
  class SettingsPage < Page

    def initialize(client,config)
      super(client,config)
    end

    def privacy?
      result = @client.checked?("restrictWallPost")
      result
    end

    def mark_privacy_setting

      xpath = "//form[@id='updateCommunicationForm']//button[@name='action']"
      css_str = 'css=form#updateCommunicationForm span.actionButton button'
      if self.privacy?
        puts "already marked nothing to do"
      else
        @client.click "restrictWallPost"
        @client.click css_str, :wait_for => :text, :text => /Successfully updated./
        @client.checked?("restrictWallPost")
      end
      
    end

    def unmark_privacy_setting
      xpath = "//form[@id='updateCommunicationForm']//button[@name='action']"
      css_str = 'css=form#updateCommunicationForm span.actionButton button'
      if self.privacy?
        @client.click "restrictWallPost"
        @client.click css_str, :wait_for => :text, :text => /Successfully updated./
        @client.checked?("restrictWallPost")
        
      else
        puts "already unmarked nothing to do"
      end
    end


  end
 end
end