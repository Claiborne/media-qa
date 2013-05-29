urls = []

File.open("/Users/wclaiborne/git/media-qa/test/performance/oyster_052013/urls.txt", "r").each_line do |line|
  urls << line
end

urls.shuffle!

File.open("/Users/wclaiborne/Desktop/urls.txt", 'w')  do |file|

  urls.each do |url|
    file.write url
  end
end