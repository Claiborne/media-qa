#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'pathconfig'
require 'rubygems'
require 'topaz_token'

include TopazToken

describe "rating_post" do

before(:all) do
  PathConfig.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
  @config = PathConfig.new
  TopazToken.set_token('social')
end

before(:each) do

end

after(:each) do
end

it "should do new rating posting for every personId for each objectId" do
  @i = 600 
  puts "xyx"
  @jdata = ""
  puts #{TopazToken.return_token}
  #puts "asd"
  while true do
    @i = @i +1
    for j in 100..50000 do
      @jdata = JSON.generate({
          "ratingType"=> "rating",
          "personId"=> @i,
          "objectType"=> "platform-game",
          "objectId"=> j,
          "ratingNumerator"=> 8,
          "ratingDenominator"=> 10
      })

    puts @jdata
  response = RestClient.put "http://media-yeti-stg.ign.com/social/v3/ratings?oauth_token=ec625482748c80af1f8ba3e8c9198632fe2e5c6a", @jdata, {:content_type => 'application/json'}
  puts response.body
  data= JSON.parse(response.body)
  puts data
  sleep(0.250)
    end

  end

end
end
