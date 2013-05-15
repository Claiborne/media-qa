urls = []

File.open("/Users/wclaiborne/Desktop/urls.txt", "r").each_line do |line|
  urls << line
end

urls.shuffle!

File.open("/Users/wclaiborne/Desktop/urls2.txt", 'w')  do |file|

  urls.each do |url|
    file.write url
  end
end