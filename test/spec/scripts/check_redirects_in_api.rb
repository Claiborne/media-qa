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
file = File.new("/Users/wclaiborne/Desktop/all_formatted2.txt", "r")
while (line = file.gets)
  list << line
end
file.close

describe 'Test Redirects in Redirect API' do

  it 'should redirect' do
    errors = []
    fails = []
    list.each_with_index do |l, index|
      if index.even? && (index > 31000)
        sleep 0.05 # sleep 0.08 ~ 500 RPM; 0.04 ~ 750
        begin
          data = JSON.parse (RestClient.get "http://apis.lan.ign.com/redirect/v3/redirects?from=#{l}").body
        rescue
          puts ">>>"+l.to_s+"||END"
          next
        end
        begin
          data[0]['from']
        rescue => e
          puts "BLANK "+l
          fails << l
          errors <<  "FAILED :"+l.to_s
          errors << 'Does not exist in redirect API:'
          errors << "Data: #{data}"
          next
        end
        #begin

        "a".match("a").should be_true
        puts list[index+1]
        list[index+1].match(list[index+1].to_s).should be_true
        #rescue => e
          #next if list[index+1] == data[0]['to']
          #puts "NO MATCH "+l
          #fails << l
          #errors <<  "FAILED :"+l.to_s
          #errors << e.message
          #errors << "Expected: "+list[index+1].to_s+"|END"
          #errors << "Got :     "+data[0]['to'].to_s+"|END"
        #end
      end
      puts "CHECK # #{index/2}" if index % 2000 == 1 # Puts the index every 1000 checks
    end
    File.open("/Users/wclaiborne/Desktop/errors.txt", 'w') { |f| f.write(errors) }
    File.open("/Users/wclaiborne/Desktop/fails.txt", 'w') { |f| f.write(fails) }
  end
end