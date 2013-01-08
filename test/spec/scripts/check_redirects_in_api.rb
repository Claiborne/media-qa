require 'rspec'
require 'rest_client'
require 'json'

list = %w(http://tv.ign.com/launch/heroes.html
http://www.ign.com/tv/heroes
http://tv.ign.com/launch/battlestar-galactica.html
http://www.ign.com/tv/battlestar-galactica-2004
http://tv.ign.com/launch/lost.html)

# Or use this list

list = []
file = File.new("/Users/wclaiborne/Desktop/all_formatted1.txt", "r")
while (line = file.gets)
  list << line.chomp.to_s
end
file.close

describe 'Test Redirects in Redirect API' do

  it 'should redirect' do
    list.each_with_index do |l, index|
      puts "."
      sleep 0.08 # ~ 700 RPM
      if index.even?
        data = JSON.parse (RestClient.get "http://apis.lan.ign.com/redirect/v3/redirects?from=#{l}").body
        begin
          data[0]['from']
        rescue => e
          puts ""
          puts l
          puts 'Does not exist in redirect API:'
          puts "Data: #{data}"
          next
        end
        begin
          data[0]['from'].should == l
          list[index+1].match(data[0]['to']).should be_true
        rescue => e
          next if list[index+1] == data[0]['to']
          puts ""
          puts e.message
          puts l.to_s
          puts "Expected: "+list[index+1].to_s+"|END"
          puts "Got :"+data[0]['to'].to_s+"|END"
        end
      end
      puts "INDEX #{index}" if index % 1000 == 1 # Puts the index every 500 checks
    end
  end

end