require 'selenium-webdriver'
require 'colorize'

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

=begin
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
=end
  driver.quit
end