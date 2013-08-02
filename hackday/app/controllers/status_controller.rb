class StatusController < ApplicationController
  
  include StatusHelper
  require 'rest_client'
 
  def show
    @status_ign = check_ign
    @status_article = check_pingable ARTICLE_API
    @status_slotter = check_slotter SLOTTER_API
    @status_video = check_pingable VIDEO_API
    @status_image = check_pingable IMAGE_API
    @status_object = check_pingable OBJECT_API
  end
  
  def manage
    
  end

end
