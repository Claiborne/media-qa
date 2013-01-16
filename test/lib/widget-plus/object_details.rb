module ObjectDetails

  def check_object_details

    it "should display the object details widget if applicable" do
      if @video_data['objectRelations'].length > 0
        @selenium.find_elements(:css => "div.column-supplement div.objectDetails div.objectDetails-header").count.should == 1
        @selenium.find_element(:css => "div.column-supplement div.objectDetails-header").text.should == 'DETAILS'
      end
    end

    it "should display the object title if applicable" do
      if @video_data['objectRelations'].length > 0
        @selenium.find_elements(:css => "div.column-supplement div.objectDetails-objectName a").count.should == 1
        @selenium.find_element(:css => "div.column-supplement div.objectDetails-objectName a").text.strip.delete('^a-zA-Z0-9').length.should > 0
      end
    end

    it "should only contain links that return 200", :spam => true do
      if @video_data['objectRelations'].length > 0
        obj_details_links =  @selenium.find_elements(:css => "div.column-supplement div.objectDetails a")
        obj_details_links.length.should > 0
        obj_details_links.each do |link|
          rest_client_not_301_home_open link.attribute('href').to_s
        end
      end
    end

  end
end