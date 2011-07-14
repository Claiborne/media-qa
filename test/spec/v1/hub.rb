require 'rest_client'
require 'json'
require 'configuration'

describe "hub services" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v1.yml"
    @config = Configuration.new
  end

  after(:each) do

  end

  it "should return global nav" do
   response = RestClient.get "Sort By"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by reviewdate
  it "should return reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?sort=reviewDate&max=5&projection=core"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sortedby popularity
  it "should return upcoming games" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?releaseStartDate=20100205&releaseEndDate=21100112&sort=popularity&max=5&projection=core"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publish date
  it "should return news" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=publishDate&max=5&type=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag with the date range
  it "should return all platforms   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&startDate=20091020&endDate=20100128&flags=ignHeadline&includePromotions=true&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return xbox360 tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=542&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return ps3 tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=543&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return pc tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=59&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return wii tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=547&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return ds tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=532&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by ignheadline tag along with platform with the date range.
  it "should return psp tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=515&startDate=20091026&endDate=20100203&flags=ignHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # by default sorted with publishdate
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # 
  it "should return myupdates" do
   response = RestClient.get "http://www.ign.com/myupdates"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by reviews
  it "should return reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&types=reviews&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by previews
  it "should return previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&types=previews&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by news and features
  it "should return news" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&types=news,features&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by videos
  it "should return videos" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&types=videos&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by images
  it "should return images" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=25&types=images&startDate=20091028&endDate=20100205&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return xbox360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return ps3" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return pc" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=20114&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return wii" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return ds" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return psp" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return xbox360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return ps3" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return pc" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=20114&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return wii" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return ds" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return psp" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity and reviews, videos
  it "should return hot reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity and previews, videos
  it "should return hot previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on publishdate
  it "should return hot game help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=542&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and news and features
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=542&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all xbox360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and downloadtype
  it "should return retail tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and downloadtype
  it "should return xboxlive   arcade" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&downloadType=1&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platformand
  it "should return all   xbox360" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and downloadtype
  it "should return retail tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platformand downloadtype
  it "should return xboxlive   arcade" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=661955&downloadType=1&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, reviews, videos
  it "should return hot xbox360   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=542&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, previews, videos
  it "should return hot xbox360   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=542&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on publishdate
  it "should return hot xbox360   game help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=661955&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=543&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid andnews and features
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=543&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all ps3" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand download type filter
  it "should return play station   store" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=201&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platformand download type filter
  it "should return psone classic" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=202&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform
  it "should return all ps3" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and download type filter
  it "should return playstation   store" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=201&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and downloadtype filter
  it "should return psone classic" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=568479&downloadType=202&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, reviews, videosand channelid
  it "should return hot ps3   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=543&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based on popularity, previews, videosand channelid
  it "should return hot ps3   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=543&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted based platform and publishdate.
  it "should return hot ps3 game   help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=568479&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=547&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and news and features
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and videos
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and images
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid.
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=547&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform
  it "should return all wii" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and download type filter
  it "should return virtual   console" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=101&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three month along with platform and download type filter
  it "should return wiiware" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=102&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform
  it "should return all wii" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and download type filter
  it "should return virtual   console" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=101&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three month along with platform and download type filter
  it "should return wiiware" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=679278&downloadType=102&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter.
  it "should return hot wii   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=547&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot wii   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=547&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate along with platform
  it "should return hot wii game   help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=679278&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with filters news and features.
  it "should return hot ds news   and features" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=532&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=59&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and reviews
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid and previews
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with news and features filter
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with videos.
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with images filter.
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channelid with the date range.
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=59&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=20114&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return " do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=20114&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter
  it "should return hot pc   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=59&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot pc   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=59&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate with platform.
  it "should return hot pc games   game help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=20114&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=532&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with reviews filter
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with previews filter
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with news and features filter
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with videos filter
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channelid with images filter
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by date range, channel id.
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=532&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return all dsi" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and download type.
  it "should return dsi ware" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&downloadType=103&releaseStartDate=20091107&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return all dsi" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and download type.
  it "should return dsi ware" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=653161&downloadType=103&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter
  it "should return hot ds   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=532&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with previews and videos filter
  it "should return hot ds   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=532&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publishdate
  it "should return hot ds game   help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=653161&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with news and features filter
  it "should return hot wii news" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=547&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by channel headline tag with the date range and channel id.
  it "should return top stories   tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=11&channelId=515&startDate=20091026&endDate=20100203&flags=channelHeadline&includePromotions=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with reviews filter
  it "should return reviews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&types=reviews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with previews filter
  it "should return previews tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&types=previews&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with news and features filter
  it "should return news tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&types=news,features&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with videos filter
  it "should return videos tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&types=videos&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid with images filter
  it "should return images tab" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&types=images&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted with date range, channelid.
  it "should return all" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?max=20&channelId=515&startDate=20091026&endDate=20100203"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform
  it "should return all psp" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=0&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and download type filter
  it "should return play station   store" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=201&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by rating based on released games with last three months along with platform and download type filter.
  it "should return psone classic" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=202&releaseStartDate=20091106&sort=rating&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform
  it "should return all ps3" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and download type filter
  it "should return retail" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=0&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and download type filter
  it "should return playstation   store" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=201&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity based on released games with next three months along with platform and download type filter
  it "should return psone classic" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/games.xml.us?network=12&platform=567173&downloadType=202&releaseStartDate=20100205&releaseEndDate=20100506&sort=popularity&max=5&projection=med"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with reviews and videos filter.
  it "should return hot psp   reviews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=515&types=reviews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with preview and videos filter.
  it "should return hot psp   previews" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=515&types=previews,videos&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by publish date
  it "should return hot psp game   help" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/guides.xml?sort=publishDate&platform=567173&max=5&dedupe=true"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

  # sorted by popularity, channelid with news and features.
  it "should return hot ps3 news" do
   response = RestClient.get "http://#{@config.options['baseurl']}/v1/articles.xml.us?sort=popularity&channelId=543&max=5&types=news,features"
   response.code.should eql(200)
   data = JSON.parse(response.body)
  end

end
