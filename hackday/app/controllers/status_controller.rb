class StatusController < ApplicationController
  
  require 'rest_client'
 
  def show
    @status_ign = check_ign
    @status_article = check_pingable ARTICLE_API
    @status_slotter = check_slotter SLOTTER_API
    @status_video = check_pingable VIDEO_API
    @status_image = check_pingable IMAGE_API
    @status_object = check_pingable OBJECT_API
  end
  
  private
  
    GREEN = {:color => 'green', :icon => 'w'}
    ORANGE = {:color => 'orange', :icon => 'e'}
    RED = {:color => 'red', :icon => 'e'}
    
    ARTICLE_API = 'http://apis.lan.ign.com/article/v3/ping'
    SLOTTER_API = 'http://apis.lan.ign.com/slotter/v3/slotters'
    VIDEO_API = 'http://apis.lan.ign.com/video/v3/ping'
    IMAGE_API = 'http://apis.lan.ign.com/image/v3/ping'
    OBJECT_API = 'http://apis.lan.ign.com/object/v3/ping'

    def check_ign
      begin
        response = RestClient.get 'http://www.ign.com/'
      rescue => e
        e.response.code
        return RED
      end
      return GREEN if response.code == 200
      RED
    end

    def check_pingable(url)
      begin
        response = RestClient.get url  
      rescue => e
       return RED 
      end
      return GREEN if response.to_s.match /pong/
      RED
    end
  
    def check_slotter(url)
      begin
        response = RestClient.get url  
      rescue => e
       return RED 
      end
      return GREEN if response.to_s.length > 10000 && response.code < 400
      RED
      
    end
    
  
end
