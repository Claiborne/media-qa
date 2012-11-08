require 'rspec'
require 'selenium-webdriver'
require 'configuration'
require 'rest-client'
require 'open_page'

include OpenPage


def set_locale(locale)

  it "should set the locale" do
    if locale=='us'
      selenium_get(@selenium, "http://www.ign.com/?setccpref=US")
      @selenium.current_url.match(/www.ign.com/).should be_true
    elsif locale=='uk'
      selenium_get(@selenium, "http://uk.ign.com/?setccpref=UK")
      @selenium.current_url.match(/uk.ign.com/).should be_true
    else
      raise "Could not set locale. Locale did not == US or UK"
    end
  end
end


######################################################################

describe "Images Gallery Page -- /images/games/far-cry-3-xbox-360-53491", :selenium => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @path = "/images/games/far-cry-3-xbox-360-53491"
    @page = "http://#{@config.options['baseurl']}#{@path}"
    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end
  
  after(:all) do
    @selenium.quit
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should open the Far Cry 3 gallery page", :smoke => true do
    @selenium.get @page
    # Do I need to wait for load?
    @selenium.current_url.match(Regexp.new(@path)).should be_true
  end

  it "should display 20 thumbnails", :smoke => true do
    @selenium.find_elements(:css => "div.imageGallery div.imageGalleryThumb a img[src*='http']").size.should == 20
  end
  
  it "should not display any broken thumbnails", :spam => true do
    @selenium.find_elements(:css => "div.imageGallery div.imageGalleryThumb a img").each do |i|
      RestClient.get(i.attribute('src')).code.should == 200
    end
  end
  
  it "should display pagination", :smoke => true do
    @selenium.find_element(:css => "div.pagination span")
    @selenium.find_elements(:css => "div.pagination a").count.should > 1
  end
  
  it "should display pagination with a link to the second page" do
   @selenium.find_element(:css => "div.pagination a").attribute('href').to_s.match(/\?page=2/).should be_true
   @selenium.find_element(:css => "div.pagination a").attribute('href').to_s.match(@path).should be_true
  end
  
  it "should display a non-broken viewer-image above the thumbnails when a thumbnail is clicked ", :smoke => true do
    page_first_thumb = @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a")
    page_first_thumb.click
    page_image = @wait.until { @selenium.find_element(:css => "div#peekWindow a img[src*='http']") }
    RestClient.get(page_image.attribute('src')).code.should == 200
  end
  
  it "should display the same viewer image that was clicked in the thumbnails", :smoke => true do
    # Regex here is poor/hacky way to compare mathcing images
    matching_thumb = @selenium.find_element(:css => "div#peekWindow a img").attribute('src').match(/\d{14,}/).to_s
    matching_viewer = @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a").attribute('ign:fullimg').match(/\d{14,}/).to_s
    matching_thumb.should == matching_viewer
  end
  
  it "should change the URL when a thumbnail is clicked", :smoke => true do
    @selenium.current_url.match(/far-cry-3-xbox-360-53491\/[0-9a-f]{24,32}/).should be_true
  end
  
  it "should display a full image in the lightbox overlay when a thumbnail is clicked", :smoke => true do
    @selenium.find_element(:css => "div#peekWindow a img[src*='http']").click
    @wait.until { @selenium.find_element(:css => "div#lbCenter a").displayed? == true }
  end
  
  it "should display in the lightbox overlay the same image that was clicked on in the image viewer", :smoke => true do
    # Regex here is poor/hacky way to compare mathcing images
    @selenium.find_element(:css => "div#peekWindow a img").attribute('src').match(/\d{14,}/).to_s.should == @selenium.find_element(:css => "div#lbCenter a").attribute('href').match(/\d{14,}/).to_s
  end
  
  it "should remove the lightbox overlay when an area outside the overlay image is clicked", :smoke => true do
    @selenium.find_element(:css, "div#lbTopContainer").click
    @wait.until { @selenium.find_element(:css => "div#lbCenter a").displayed? == false }
  end

  it "should display the appropriate images and URLs when the back and forward browser buttons are clicked", :smoke => true do
    # Set variables for the starting image and starting URL:
    starting_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    starting_url = @selenium.current_url
    
    # Click the second thumbnail image and wait until it replaces the starting image in the viewer
    @selenium.find_element(:css => "div.imageGallery div:nth-child(3).imageGalleryThumb a").click
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') != starting_image }
    next_image = @selenium.find_element(:css => "div#peekWindow a img")
    @wait.until { next_image.attribute('src') != starting_image }
    
    # Wait for the URL to change
    @wait.until { @selenium.current_url != starting_url }
    
    # Press the back button on the browser
    @selenium.navigate.back
    
    # Wait for the starting image to replace the previous image
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == starting_image }
    
    # Wait for the URL to change to the starting URL
    @wait.until { @selenium.current_url == starting_url }
      
    # Check clicking back from here takes you to the original gallery page with no image in the viewr
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").displayed? == false }
    @wait.until { @selenium.current_url.match(@path) }
    
    # Check clicking forward from here takes you back to the previous image you were viewing
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == starting_image }
    @wait.until { @selenium.current_url == starting_url }
  end

  it "should display the appropriate images and URLs when the back and forward browser buttons are clicked through pagination" do
    selenium_get(@selenium, @page)
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img") }
    first_image = @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    first_url = @selenium.current_url
    
    # Click thumb
    @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a").click
    @wait.until { first_image != @selenium.find_element(:css => "div#peekWindow a img").attribute('src') }
    second_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    second_url = @selenium.current_url
    
    # Click thumb
    @selenium.find_element(:css => "div.imageGallery div:nth-child(3).imageGalleryThumb a").click
    @wait.until { second_image != @selenium.find_element(:css => "div#peekWindow a img").attribute('src') }
    third_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    third_url = @selenium.current_url
    
    # Click second page
    @selenium.find_element(:css => "div.pagination a").click
    @wait.until { third_image != @selenium.find_element(:css => "div#peekWindow a img").attribute('src') }
    fourth_image = @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    fourth_url = @selenium.current_url
    
    # Click thumb
    @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a").click
    @wait.until { fourth_image != @selenium.find_element(:css => "div#peekWindow a img").attribute('src') }
    fifth_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    fifth_url = @selenium.current_url
    
    # Click thumb
    @selenium.find_element(:css => "div.imageGallery div:nth-child(3).imageGalleryThumb a").click
    @wait.until { fifth_image != @selenium.find_element(:css => "div#peekWindow a img").attribute('src') }
    sixth_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    sixth_url = @selenium.current_url
    
    # Assert browser back works
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == fifth_image }
    @wait.until { @selenium.current_url == fifth_url }
    
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").displayed? == false }
    @wait.until { @selenium.current_url == fourth_url }
    
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == third_image }
    @wait.until { @selenium.current_url == third_url }
    
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == second_image }
    @wait.until { @selenium.current_url == second_url }
    
    @selenium.navigate.back
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").displayed? == false }
    @wait.until { @selenium.current_url == first_url }
    
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == second_image }
    @wait.until { @selenium.current_url == second_url }
    
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == third_image }
    @wait.until { @selenium.current_url == third_url }
    
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").displayed? == false }
    @wait.until { @selenium.current_url == fourth_url }
    
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == fifth_image }
    @wait.until { @selenium.current_url == fifth_url }
    
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == sixth_image }
    @wait.until { @selenium.current_url == sixth_url }

  end

end
