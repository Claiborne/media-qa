module VideoPlayerPageHelper
  def get_latest_videos(count)

    DataConfig.config_path = File.dirname(__FILE__) + "/../config/v3_video.yml"
    data_config = DataConfig.new

    list_of_date_and_slugs = []
    latest_vids_response = RestClient.get "http://#{data_config.options['baseurl']}/v3/videos?count=#{count}&sortBy=metadata.publishDate&sortOrder=desc&metadata.networks=ign"
    latest_vids = JSON.parse(latest_vids_response.body)
    latest_vids['data'].each do |v|
      list_of_date_and_slugs << v['metadata']['url'].match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/[^?]{1,}/).to_s
    end
    list_of_date_and_slugs
  end

  def get_api_titles(d)
    api_titles = []
    d['data'].each do |v|
      video_long_title = false
      begin
        video_long_title = v['metadata']['longTitle']
        if video_long_title.nil?; throw Exception.new end
      rescue
        video_long_title = false
        video_title = v['metadata']['title'].strip
        begin
          object_name =  v['objectRelations'][0]['objectName'].strip+" - "
        rescue
          object_name = ""
        end
      end

      if video_long_title == false
        api_titles << (object_name+video_title).downcase.gsub(/\s{2,}/, ' ')
      else
        api_titles << video_long_title.downcase.strip.gsub(/\s{2,}/, ' ')
      end
    end
    api_titles
  end

  def get_api_title(d)
    api_title = ''
    video_long_title = false
    begin
      video_long_title = d['metadata']['longTitle']
      if video_long_title.nil?; throw Exception.new end
    rescue
      video_long_title = false
      video_title = d['metadata']['title'].strip
      begin
        object_name =  d['objectRelations'][0]['objectName'].strip+" - "
      rescue
        object_name = ""
      end
    end

    if video_long_title == false
      api_title << (object_name+video_title).downcase
    else
      api_title << video_long_title.downcase.strip
    end
    api_title
  end

end