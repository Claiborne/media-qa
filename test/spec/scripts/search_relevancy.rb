require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

['halo 4','halo'].each do |q|
%w(object article video wiki).each do |type|
describe "V3 Search API -- Relevancy for #{q.upcase}" do

  def obj(ob)
    case ob
      when 'gameId'
        return 'games/'
      when 'movieId'
        return 'movies/'
      when 'volumeId'
        return 'volumes/'
      when 'bookId'
        return 'books/'
      when 'showId'
        return 'shows/'
      when 'seasonId'
        return 'seasons/'
      when 'episodeId'
        return 'episodes/'
      when  'personId'
        return 'people/'
      when 'characterId'
        return 'characters/'
      when 'companyId'
        return 'companies/'
      else
        Exception.new "Invalid Object Type: #{ob}"
    end
  end

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_search.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/search?q=#{q}&type=#{type}&count=20".gsub(' ','+')

    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    @object_url = "http://#{@config.options['baseurl']}/"

    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_articles.yml"
    @config = PathConfig.new
    @article_url = "http://#{@config.options['baseurl']}/v3/articles/"

    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_video.yml"
    @config = PathConfig.new
    @video_url = "http://#{@config.options['baseurl']}/v3/videos/"

    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse @response.body
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should print results" do
    puts "********** #{q.upcase} #{type.upcase }**********"
    @data['data'].each do |result|
      case type
        when 'object'
          endpoint = obj result.keys[0]
          begin
            object_name = JSON.parse(RestClient.get(@object_url+endpoint+result[result.keys[0]]).body)['metadata']['slug']
          rescue => e
            raise Exception.new(e.message+" "+@object_url+endpoint+result[result.keys[0]])
          end
          object_type = endpoint.upcase
          puts object_type+" "+object_name
        when 'article'
          begin
            puts JSON.parse(RestClient.get(@article_url+result['articleId']).body)['metadata']['publishDate'].match(/\d\d\d\d-\d\d-\d\d/)
          rescue => e
            raise Exception.new(e.message+" "+@article_url+result['articleId'])
          end
        when 'video'
          begin
            puts JSON.parse(RestClient.get(@video_url+result['videoId']).body)['metadata']['publishDate'].match(/\d\d\d\d-\d\d-\d\d/)
          rescue => e
            raise Exception.new(e.message+" "+@video_url+result['videoId'])
          end
        when 'wiki'
          #TODO print title?
        else
          Exception.new 'Invalid Type Value'
      end
    end
  end

end end end