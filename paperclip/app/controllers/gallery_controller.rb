class GalleryController < ApplicationController
  def index
    @projects = Image.group("project")
    
    respond_to do |format|
        format.html 
        format.xml  { render :xml => @keys }
    end
  end
  
  def build_index
    @projects = Image.where(:project => params[:projectname])
    @projects = @projects.group("build")
      
    @project_name = params[:projectname]
  end

  def view
    @project = Image.where(:project => params[:projectname])
    @pages = Image.where(:project => params[:projectname], :build => params[:build_num])
     
    @project_name = params[:projectname]
     
    @ie7 =       @pages.where(:browser => "ie7")
    @ie8 =       @pages.where(:browser => "ie8")
    @ie9 =       @pages.where(:browser => "ie9")     
    @ff3 =       @pages.where(:browser => "firefox3")
    @ff4 =       @pages.where(:browser => "firefox4")
    @chrome =    @pages.where(:browser => "chrome")
    @safari =    @pages.where(:browser => "safari")
    
    respond_to do |format|
      format.html 
        format.json { render :json => @res.to_json }      
      format.xml  { render :xml => @res }
    end

  end

end
