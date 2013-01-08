require 'rspec'
require 'rest_client'
require 'json'

list = %w(http://tv.ign.com/launch/heroes.html
http://www.ign.com/tv/heroes
http://tv.ign.com/launch/battlestar-galactica.html
http://www.ign.com/tv/battlestar-galactica-2004
http://tv.ign.com/launch/lost.html
http://www.ign.com/tv/lost
http://movies.ign.com/launch/dragonball-evolution.html
http://www.ign.com/movies/dragonball-evolution/theater-479331
http://movies.ign.com/launch/fast-and-furious.html
http://www.ign.com/movies/fast-furious/theater-959256
http://movies.ign.com/launch/friday-the-13th.html
http://www.ign.com/movies/friday-the-13th-2009/theater-811606
http://movies.ign.com/launch/indiana-jones-and-the-kingdom-of-the-crystal-skull.html
http://www.ign.com/movies/indiana-jones-and-the-kingdom-of-the-crystal-skull/theater-33714
http://movies.ign.com/launch/iron-man.html
http://www.ign.com/movies/iron-man/theater-34317
http://movies.ign.com/launch/the-incredible-hulk.html
http://www.ign.com/movies/the-incredible-hulk/theater-569136
http://movies.ign.com/launch/street-fighter.html
http://www.ign.com/movies/street-fighter-the-legend-of-chun-li/theater-863597
http://movies.ign.com/launch/the-dark-knight.html
http://www.ign.com/movies/the-dark-knight/theater-752133
http://movies.ign.com/launch/the-incredible-hulk.html
http://www.ign.com/movies/the-incredible-hulk/theater-569136
http://movies.ign.com/launch/watchmen.html
http://www.ign.com/movies/watchmen/theater-34260
http://xbox360.ign.com/halo3launch/
http://www.ign.com/games/halo-3/xbox-360-734817
http://xbox360.ign.com/launch/banjo-kazooie-nuts-and-bolts.html
http://www.ign.com/games/banjo-kazooie-nuts-bolts/xbox-360-15334
http://xbox360.ign.com/launch/fable-ii.html
http://www.ign.com/games/fable-ii/xbox-360-741361
http://xbox360.ign.com/launch/fallout-3.html
http://www.ign.com/games/fallout-3/xbox-360-882301
http://xbox360.ign.com/launch/gears-of-war-2.html
http://www.ign.com/games/gears-of-war-2/xbox-360-14232680
http://xbox360.ign.com/launch/grand-theft-auto-iv.html
http://www.ign.com/games/grand-theft-auto-iv/xbox-360-827005
http://xbox360.ign.com/launch/guitar-hero-3.html
http://www.ign.com/games/guitar-hero-iii-legends-of-rock/xbox-360-899096
http://xbox360.ign.com/launch/guitar-hero-metallica.html
http://www.ign.com/games/guitar-hero-metallica/xbox-360-14257538
http://xbox360.ign.com/launch/guitar-hero-world-tour.html
http://www.ign.com/games/guitar-hero-world-tour/xbox-360-14272830
http://xbox360.ign.com/launch/halo-wars.html
http://www.ign.com/games/halo-wars/xbox-360-857436
http://xbox360.ign.com/launch/madden-nfl-09.html
http://www.ign.com/games/madden-nfl-09/xbox-360-14229536
http://xbox360.ign.com/launch/mass-effect.html
http://www.ign.com/games/mass-effect/xbox-360-718963
http://xbox360.ign.com/launch/mercenaries-2-world-in-flames.html
http://www.ign.com/games/mercenaries-2-world-in-flames/xbox-360-793794
http://xbox360.ign.com/launch/mortal-kombat-vs-dc-universe.html
http://www.ign.com/games/mortal-kombat-vs-dc-universe/xbox-360-853443
http://xbox360.ign.com/launch/mortal-kombat-vs-dc-universe2.html
http://www.ign.com/games/mortal-kombat-vs-dc-universe/xbox-360-853443
http://xbox360.ign.com/launch/ninja-gaiden-ii.html
http://www.ign.com/games/ninja-gaiden-ii/xbox-360-686645
http://xbox360.ign.com/launch/prince-of-persia.html
http://www.ign.com/games/prince-of-persia/xbox-360-890664
http://xbox360.ign.com/launch/rainbow-six-vegas-2.html
http://www.ign.com/games/tom-clancys-rainbow-six-vegas-ghost-recon-advanced-warfighter-2-games-one-low-price/xbox-360-815419
http://xbox360.ign.com/launch/resident-evil-5.html
http://www.ign.com/games/resident-evil-5/xbox-360-760880
http://xbox360.ign.com/launch/rock-band-2.html
http://www.ign.com/games/rock-band-2/xbox-360-14257567
http://xbox360.ign.com/launch/saints-row-2.html
http://www.ign.com/games/saints-row-2/xbox-360-882586
http://xbox360.ign.com/launch/star-ocean-the-last-hope.html
http://www.ign.com/games/star-ocean-the-last-hope/xbox-360-903309
http://xbox360.ign.com/launch/tomb-raider-underworld.html
http://www.ign.com/games/tomb-raider-trilogy/xbox-360-14224305
http://xbox360.ign.com/launch/too-human.html
http://www.ign.com/games/too-human/xbox-360-748783
http://pc.ign.com/launch/fear-2-project-origin.html
http://www.ign.com/games/fear-2-project-origin/pc-812589
http://pc.ign.com/launch/spore.html	http://www.ign.com/games/spore/pc-735340
http://pc.ign.com/launch/unreal-tournament-3.html
http://www.ign.com/games/unreal-engine-3-project/pc-746632
http://pc.ign.com/launch/warhammer-online-age-of-reckoning.html
http://www.ign.com/games/warhammer-online-age-of-reckoning/pc-748723
http://pc.ign.com/launch/world-of-warcraft-wrath-of-the-lich-king.html
http://www.ign.com/games/world-of-warcraft-wrath-of-the-lich-king/pc-954150
http://wii.ign.com/launch/animal-crossing-city-folk.html
http://www.ign.com/games/animal-crossing-city-folk/wii-748892
http://wii.ign.com/launch/madworld.html	http://www.ign.com/games/madworld/wii-14253678
http://wii.ign.com/launch/mario-kart-wii.html
http://www.ign.com/games/mario-kart-wii/wii-949580
http://wii.ign.com/launch/samba-de-amigo.html
http://www.ign.com/games/samba-de-amigo-966055/wii-966047
http://wii.ign.com/launch/super-mario-galaxy.html
http://www.ign.com/games/super-mario-galaxy/wii-748588
http://wii.ign.com/launch/super-smash-bros-brawl.html
http://www.ign.com/games/super-smash-bros-brawl/wii-748545
http://wii.ign.com/launch/wii-fit.html
http://www.ign.com/games/wii-fit/wii-949581
http://ps3.ign.com/launch/assassins-creed.html
http://www.ign.com/games/assassins-creed/ps3-772025
http://ps3.ign.com/launch/dark-sector.html
http://www.ign.com/games/dark-sector/ps3-674095
http://ps3.ign.com/launch/gran-turismo-5-prologue.html
http://www.ign.com/games/gran-turismo-5/ps3-857126
http://ps3.ign.com/launch/killzone-2.html
http://www.ign.com/games/killzone-2/ps3-748475
http://ps3.ign.com/launch/littlebigplanet.html
http://www.ign.com/games/littlebigplanet-891799/ps3-856680
http://ps3.ign.com/launch/metal-gear-solid-4.html
http://www.ign.com/games/metal-gear-solid-4-guns-of-the-patriots/ps3-714044
http://ps3.ign.com/launch/midnight-club-los-angeles.html
http://www.ign.com/games/midnight-club-la-remix-spike-the-best/ps3-906843
http://ps3.ign.com/launch/resistance-2.html
http://www.ign.com/games/resistance-2/ps3-14211237
http://ps3.ign.com/launch/socom-confrontation.html
http://www.ign.com/games/socom-confrontation/ps3-906076
http://ps3.ign.com/launch/soulcalibur-iv.html
http://www.ign.com/games/soulcalibur-iv/ps3-739576
http://ps3.ign.com/launch/star-wars-the-force-unleashed.html
http://www.ign.com/games/star-wars-the-force-unleashed/ps3-823668
http://ps3.ign.com/launch/street-fighter-iv.html
http://www.ign.com/games/street-fighter-iv/ps3-14211548
http://ps3.ign.com/launch/wwe-smackdown-vs-raw-2008.html
http://www.ign.com/games/wwe-smackdown-vs-raw-2008/ps3-844743
http://ps3.ign.com/launch/wwe-smackdown-vs-raw-2009.html
http://www.ign.com/games/wwe-smackdown-vs-raw-2009/ps3-14242649)

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
          list[index+1].to_s.match(data[0]['to']).should be_true
        rescue => e
          puts ""
          puts e.message
          puts l.to_s
          puts list[index+1].to_s
          puts "Data: #{data}"
        end
      end
    end
  end

end