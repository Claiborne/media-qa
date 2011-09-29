module TagCoverStories
  
  def widget_tag_cover_stories
    
    it "should not be missing from the page", :stg => true do
      @doc.at_css('div.topStories div.storyItems').should be_true
    end
    
    #test for css file?
    #test for .js file $this->view->extra_js[] = $this->view->static_url_paths['network']['js'].'/tagcoverstories.js';
    
   #all feilds of one kind not blank
    
  end
end