video = []
search = []

File.open('/Users/wclaiborne/git/media-qa/test/performance/phantom_062013/phantom_urls.txt', "r").each_line do |line|
  if line.match(/\/videos\//)
    video << line  
  else
    search << line 
  end
end

File.open('/Users/wclaiborne/Desktop/phantom_video_urls.txt', 'w') do |file| 
  video.each {|v| file.write(v)}
end

File.open('/Users/wclaiborne/Desktop/phantom_search_urls.txt', 'w') do |file| 
  search.each {|s| file.write(s)}
end