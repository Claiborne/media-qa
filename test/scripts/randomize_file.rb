urls = []

File.open("/Users/wclaiborne/Desktop/video_api_urls2.txt", "r").each_line do |line|
  urls << line
end

urls.shuffle!

File.open("/Users/wclaiborne/Desktop/video_api_urls.txt", 'w')  do |file|

  urls.each do |url|
    file.write url
  end
end