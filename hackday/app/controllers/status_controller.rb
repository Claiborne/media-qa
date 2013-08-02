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
    case @status[:status]
    when 'green'
      @error_field_display = "display:none;"
      @status_display = 'Normal' 
    when 'orange'
      @error_field_display = "display:block;"
      @status_display = 'Partial Outage' 
    when 'red'
      @error_field_display = "display:block;"
      @status_display = 'Severe Outage' 
    else
      @error_field_display = "display:block;"
      @status_display = 'Uninitialized Status'
    end 
  end
  
  def update
    @status = Status.find params[:id]
    
    if @status.update_attributes params[:status]
      
      if @status[:status] == 'green'
        @status.update_attribute(:custom, false)
      else
        @status.update_attribute(:custom, true)
      end
      
      redirect_to "/status"
    else
      #render 'edit'
    end
    
  end

end
