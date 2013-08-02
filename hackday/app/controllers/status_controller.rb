class StatusController < ApplicationController
  
  include StatusHelper
  require 'rest_client'
 
  def overview
    @status_ign = check_ign
    @status_article = check_pingable ARTICLE_API
    @status_slotter = check_slotter SLOTTER_API
    @status_video = check_pingable VIDEO_API
    @status_image = check_pingable IMAGE_API
    @status_object = check_pingable OBJECT_API
  end
  
  def edit
    @status = Status.find params[:id]
  end
  
  def update
    @status = Status.find params[:id]
    if @status.update_attributes params[:status]
      puts "PARMS::::"
      puts params[:status]
      redirect_to "/status"
    else
      #render 'edit'
    end
    
  end

end
