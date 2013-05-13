require 'selenium-webdriver'
require 'colorize'

urls = %w(
http://www.ign.com/boards
http://www.ign.com/boards/forums/the-vestibule.5296/
http://www.ign.com/boards/forums/xbox.8271/
http://www.ign.com/boards/threads/the-bad-changes-to-halo-4-by-343-industries.452950011/
http://www.ign.com/boards/threads/tales-of-vesperia-vs-lost-odyssey-vs-ff12-ps2-what-rpg-should-i-play-next.452947759/
http://www.ign.com/boards/threads/anyone-remember-this-a-few-months-back-ms-registering-microsoft-sony-com.452946117/
http://www.ign.com/boards/recent-activity/
)

urls = %w(http://internal-media-apis-boards-80200747.us-east-1.elb.amazonaws.com/board/v3/boards/legacyId/229 http://internal-media-apis-boards-80200747.us-east-1.elb.amazonaws.com/board/v3/boards/legacyId/229 http://internal-media-apis-boards-80200747.us-east-1.elb.amazonaws.com/board/v3/boards/legacyId/229 http://internal-media-apis-boards-80200747.us-east-1.elb.amazonaws.com/board/v3/boards/legacyId/229 http://internal-media-apis-boards-80200747.us-east-1.elb.amazonaws.com/board/v3/boards/legacyId/229)

puts "-- AVERAGES --".blue
=begin
response_times = []
file = File.new("/Users/wclaiborne/Desktop/boardsperf/responsetime.txt", "r")
while (line = file.gets)
  response_times << line.to_i
end
file.close

dom_load_times = []
file = File.new("/Users/wclaiborne/Desktop/boardsperf/domloaded.txt", "r")
while (line = file.gets)
  dom_load_times << line.to_f
end
file.close

on_load_times = []
file = File.new("/Users/wclaiborne/Desktop/boardsperf/onload.txt", "r")
while (line = file.gets)
  on_load_times << line.to_f
end
file.close

puts "  AVG RESPONSE TIMES: #{(response_times.inject{|sum,x| sum + x })/response_times.length}".blue
puts "  AVG DOM LOAD TIMES: #{(dom_load_times.inject{|sum,x| sum + x }).to_f/dom_load_times.length.to_f}".blue
puts "  AVG ON LOAD TIMES: #{(on_load_times.inject{|sum,x| sum + x }).to_f/on_load_times.length.to_f}".blue
puts ''
=end
urls.each do |url|

  puts url.yellow

  @selenium = Selenium::WebDriver.for :firefox
  @selenium.get url

  timing = @selenium.execute_script("return window.performance.timing")

  #response time
  rt = timing['responseEnd'] - timing['requestStart']
  puts "    RESPONSE TIME: #{rt} MS".green
  #File.open("/Users/wclaiborne/Desktop/boardsperf/responsetime.txt", 'a') { |file| file.puts(rt) }

  #dom load
  #dl = timing['domContentLoadedEventEnd'] - timing['navigationStart']
  #puts "    DOM LOAD TIME: #{dl/1000.to_f} Seconds".green
  #File.open("/Users/wclaiborne/Desktop/boardsperf/domloaded.txt", 'a') { |file| file.puts(dl/1000.to_f) }

  #on load
  #ol = timing['loadEventEnd'] - timing['navigationStart']
  #puts "    ON LOAD TIME: #{ol/1000.to_f} Seconds".green
  #File.open("/Users/wclaiborne/Desktop/boardsperf/onload.txt", 'a') { |file| file.puts(ol/1000.to_f) }

  puts ''

  @selenium.quit

end

=begin
puts ''
puts "-------------- WWW.IGN.COM/BOARDS --------------".yellow
puts ''
[
#['firefox', '18', 'Mac 10.6', 'Firefox on Mac'],
#['chrome', nil, 'Mac 10.8', 'Chrome on Mac'],
['ie', '9', 'Windows 2008', 'IE 10 on Windows 8'],
#['firefox', '18', 'Windows 2008', 'Firefox on Windows 7'],
#['chrome', nil, 'Windows 2008', 'Chrome on Windows 7']
].each do |env|
  case env[0]
    when 'ie'
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
    when 'firefox'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
    when 'chrome'
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
  end
  caps.javascript_enabled = true
  caps.native_events = true
  caps.version = env[1] if env[1]
  caps.platform = env[2]
  caps[:name] = "Performance: #{env[3]}"

  driver = Selenium::WebDriver.for(
      :remote,
      :url => "http://Clay:5f79fbf9-be2e-4d7d-9159-24de2ef3bf2e@ondemand.saucelabs.com:80/wd/hub",
      :desired_capabilities => caps)
  driver.navigate.to "http://www.google.com"

    puts "  #{env[3]}"



    puts driver.execute_script('window.focus();')
    puts driver.execute_script("return window.performance.timing").class
    #puts driver.execute_script("return window").class


    timing = driver.execute_script("return window.performance.timing")

    #response time
    rt = timing['responseEnd'] - timing['requestStart']
    puts "    RESPONSE TIME: #{rt} MS".green

    #dom load
    dl = timing['domContentLoadedEventEnd'] - timing['navigationStart']
    puts "    DOM LOAD TIME: #{dl/1000.to_f} Seconds".green

    #on load
    ol = timing['loadEventEnd'] - timing['navigationStart']
    puts "    ON LOAD TIME: #{ol/1000.to_f} Seconds".green

    puts ''

  driver.quit
end
=end