require 'rspec'
require 'selenium-webdriver'
require 'configuration'
require 'rest-client'
=begin
# =>  TODO:
#
# =>  IMPLEMENT BROWSER AND ENV
#
# =>  CHECK WHEN TO IMPLEMENT WAIT METHODS
#
# =>  BROWSER AND PAGE CLASS IN LIB FOR COMMON METHODS

describe "Images HomePage:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/images"
    puts @page
    @selenium = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end
  
  after(:all) do
    @selenium.quit
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should 301 from /images to /index/images.html", :smoke => true do
    @selenium.get @page
    #
    # Wait for page somehow
    #
    @selenium.current_url.should == "http://#{@config.options['baseurl']}/index/images.html"
  end
  
end
=end
describe "Images Gallery Page:", :selenium => true do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/images/games/far-cry-3-xbox-360-53491"
    puts @page
    @selenium = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end
  
  after(:all) do
    @selenium.quit
  end

  before(:each) do
    
  end

  after(:each) do

  end
=begin
  it "should open the Far Cry 3 gallery page", :smoke => true do
    @selenium.get @page
    #
    # Wait for page somehow
    #
    @selenium.current_url.should == @page
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
    @selenium.find_element(:css => "div.pagination a")
  end
  
  it "should display pagination with a link to the second page" do
   @selenium.find_element(:css => "div.pagination a").attribute('href').match(/\?page=2/)
  end
  
  it "should display a non-broken image above the thumbnails when a thumbnail is clicked ", :smoke => true do
    page_first_thumb = @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a")
    page_first_thumb.click
    page_image = @wait.until { @selenium.find_element(:css => "div#peekWindow a img[src*='http']") }
    RestClient.get(page_image.attribute('src')).code.should == 200
  end
  
  it "should change the URL when a thumbnail is cliked", :smoke => true do
    @selenium.current_url.match(/far-cry-3-xbox-360-53491\/\d\d\d/).should be_true
  end
  
  it "should display the appropriate images and URLs when the back and forward browser buttons are clicked", :smoke => true do
    # Set variables for the starting image and starting UR:
    starting_image =  @selenium.find_element(:css => "div#peekWindow a img").attribute('src')
    starting_url = @selenium.current_url
    
    # Click the second thumbnail image and wait until it replaces the starting image in the viewer
    @selenium.find_element(:css => "div.imageGallery div:nth-child(2).imageGalleryThumb a").click
    #
    # wait somehow
    #
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
    @wait.until { @selenium.current_url == @page }
    
    # Check clicking forward from here takes you back to the previous image you were viewing
    @selenium.navigate.forward
    @wait.until { @selenium.find_element(:css => "div#peekWindow a img").attribute('src') == starting_image }
    @wait.until { @selenium.current_url == starting_url }
    
  end
=end
  it "should display the appropriate images and URLs when the back and forward browser buttons are clicked through pagination" do
    @selenium.get @page
    #
    # wait somehow
    #
    first_image = @wait.until { @selenium.find_element(:css => "div#peekWindow a img") }
    first_url = @selenium.current_url
    
    (@wait.until { @selenium.find_element(:css => "div.imageGallery div.imageGalleryThumb a" }).click
    @wait.until 
    second_image = 
  end
  

  
end
