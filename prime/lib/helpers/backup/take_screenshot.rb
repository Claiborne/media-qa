require "rubygems"
require "selenium"

require "restclient"
#require "aws/s3"

module ScreenshotHelper
  
  def take_screenshot(project, build, page, browser, filename)
    filepath = 'C:/Users/fklun/Documents/Development/Prime/screenshots/'

    @client.capture_page_screenshot("#{filepath}#{filename}.png")
    
#     RestClient.post( 'http://ec2-204-236-142-34.us-west-1.compute.amazonaws.com/images/create',
#        { :image => { 
#            :project  => project,
#            :build    => build,
#            :page     => page,
#            :browser  => browser,
#            :image    => File.new("#{filepath}#{filename}.png", 'rb')
#        }
#     },
#     :multipart => true)
    
#    RestClient.post( 'http://localhost:3000/images/create',
#       { :image => { 
#        :key => 'PrimeTest1', 
#        :name => 'thankyou', 
#        :browser => 'firefox', 
#        :image => File.new('..\Screenshots\testing123.bmp', 'rb')
#      }
#    },
#    :multipart => true)   
  end
end