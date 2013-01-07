require 'rest_client'
require 'json'
require 'pathconfig'

describe "hub services" do

  before(:all) do

  end

  before(:each) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = PathConfig.new
  end

  after(:each) do

  end

  #it "should return global nav", :type => 'smoketest' do
  # response = RestClient.get "Sort By"
  # response.code.should eql(200)
  # data = JSON.parse(response.body)
  #end

  # sorted by reviewdate
  it "should return reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?sort=reviewDate&max=5&projection=core"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sortedby popularity
  it "should return upcoming games", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?releaseStartDate=20100205&releaseEndDate=21100112&sort=popularity&max=5&projection=core"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publish date
  it "should return news", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=publishDate&max=5&type=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag with the date range
  it "should return all platforms   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&startDate=20091020&endDate=20100128&flags=ignHeadline&includePromotions=true&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return xbox360 tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=542&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return ps3 tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=543&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return pc tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=59&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return wii tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=547&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return ds tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=532&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return psp tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=515&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # by default sorted with publishdate
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  #this is not an api test
  #it "should return myupdates", :type => 'smoketest' do
  # response = RestClient.get "http://www.ign.com/myupdates"
  # response.code.should eql(200)
  # data = JSON.parse(response.body)
  #end

  # sorted by reviews
  it "should return reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&types=reviews&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by previews
  it "should return previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&types=previews&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by news and features
  it "should return news", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&types=news,features&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by videos
  it "should return videos", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&types=videos&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by images
  it "should return images", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=25&types=images&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return xbox360", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return ps3", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return pc", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=20114&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return wii", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return ds", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return psp", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return xbox360", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return ps3", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return pc", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=20114&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return wii", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return ds", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return psp", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity and reviews, videos
  it "should return hot reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity and previews, videos
  it "should return hot previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on publishdate
  it "should return hot game help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=542&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and news and features
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=542&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all xbox360", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and, :type => 'smoketest' downloadtype
  it "should return retail tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and, :type => 'smoketest' downloadtype
  it "should return xboxlive   arcade", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&downloadType=1&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platformand
  it "should return all   xbox360", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' downloadtype
  it "should return retail tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platformand, :type => 'smoketest' downloadtype
  it "should return xboxlive   arcade", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=661955&downloadType=1&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, reviews, videos
  it "should return hot xbox360   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=542&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, previews, videos
  it "should return hot xbox360   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=542&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on publishdate
  it "should return hot xbox360   game help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=661955&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=543&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid andnews and features
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=543&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all ps3", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand, :type => 'smoketest' download type filter
  it "should return play station   store", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=201&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand, :type => 'smoketest' download type filter
  it "should return psone classic", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=202&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform
  it "should return all ps3", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' download type filter
  it "should return playstation   store", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=201&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' downloadtype filter
  it "should return psone classic", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=568479&downloadType=202&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, reviews, videosand channelid
  it "should return hot ps3   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=543&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, previews, videosand channelid
  it "should return hot ps3   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=543&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based platform and publishdate.
  it "should return hot ps3 game   help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=568479&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=547&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and news and features
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid.
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=547&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all wii", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and, :type => 'smoketest' download type filter
  it "should return virtual   console", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=101&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and, :type => 'smoketest' download type filter
  it "should return wiiware", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=102&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform
  it "should return all wii", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' download type filter
  it "should return virtual   console", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=101&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and, :type => 'smoketest' download type filter
  it "should return wiiware", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=679278&downloadType=102&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter.
  it "should return hot wii   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=547&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot wii   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=547&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate along with platform
  it "should return hot wii game   help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=679278&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with filters news and features.
  it "should return hot ds news   and features", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=532&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=59&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with news and features filter
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with videos.
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with images filter.
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channelid with the date range.
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=59&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return ", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=20114&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return ", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=20114&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter
  it "should return hot pc   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=59&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot pc   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=59&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate with platform.
  it "should return hot pc games   game help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=20114&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=532&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with reviews filter
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with previews filter
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with news and features filter
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with videos filter
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with images filter
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channel id.
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=532&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return all dsi", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and, :type => 'smoketest' download type.
  it "should return dsi ware", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&downloadType=103&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return all dsi", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and, :type => 'smoketest' download type.
  it "should return dsi ware", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=653161&downloadType=103&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter
  it "should return hot ds   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=532&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot ds   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=532&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate
  it "should return hot ds game   help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=653161&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with news and features filter
  it "should return hot wii news", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=547&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=11&channelId=515&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with reviews filter
  it "should return reviews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with previews filter
  it "should return previews tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with news and features filter
  it "should return news tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with videos filter
  it "should return videos tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with images filter
  it "should return images tab", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid.
  it "should return all", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?max=20&channelId=515&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return all psp", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and, :type => 'smoketest' download type filter
  it "should return play station   store", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=201&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and, :type => 'smoketest' download type filter.
  it "should return psone classic", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=202&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return all ps3", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and, :type => 'smoketest' download type filter
  it "should return retail", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and, :type => 'smoketest' download type filter
  it "should return playstation   store", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=201&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and, :type => 'smoketest' download type filter
  it "should return psone classic", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.json.us?network=12&platform=567173&downloadType=202&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter.
  it "should return hot psp   reviews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=515&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with preview and videos filter.
  it "should return hot psp   previews", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=515&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publish date
  it "should return hot psp game   help", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.json?sort=publishDate&platform=567173&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with news and features.
  it "should return hot ps3 news", :type => 'smoketest' do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.json.us?sort=popularity&channelId=543&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

end
