require 'rspec'
require 'rest_client'
require 'json'
require 'pathconfig'
#require 'rubygems'
#require 'topaz_token'

#include TopazToken

describe "test_person" do
person_id = ""
people_activity_id = ""
follow_person_id = "10000"
verb = "FOLLOW"
actorType = "PERSON"
level = "New level achieved 2"
media_activity_id = ""
mediaItem_id = 65500
verb = "FOLLOW"
actorType = "PERSON"
wishList = true
released = true
unreleased = false
rating = "6"
accounts_id = "WII_ID"
gamerCard_type = "GAMER_CARD"
topaz_id = 0
testEmail =""


before(:all) do
  PathConfig.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
  @config = PathConfig.new
  @id = "#{Random.rand(60000000-900000000)}"
  @nickname = "socialtesti2_#{Random.rand(200-9999)}"
  @joined = "#{@nickname} joined the community"
  #TopazToken.set_token('social')


end

before(:each) do

end

after(:each) do
end

  it "should match the personId from new registration" do
    response = RestClient.get "http://#{@config.options['baseurl']}/v1.0/social/rest/people/nickname.socialtesti2_4197/@self"
    data = JSON.parse(response.body)
    puts response.body
    sleep(5)
    person_id.to_s().should eql(data["entry"][0]["id"].to_s())

  end
end