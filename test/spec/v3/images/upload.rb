require 'rspec'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include TopazToken
include Assert
=begin
################################################################################

describe "V3 Image API -- Should Upload An Image", :upload => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_images.yml"
    @config = PathConfig.new
    TopazToken.set_token('images')
    @url = "http://media-image-stg-services-01.sfdev.colo.ignops.com:8080/image/upload?oauth_token=#{TopazToken.return_token}"
    @url = @url.to_s.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should' do

    contents = File.open("/Users/wclaiborne/Desktop/rails.png", 'rb').read

    File.open("/Users/wclaiborne/Desktop/x.jpg", 'wb') { |file|
      file << contents
    }
  end
end
=end