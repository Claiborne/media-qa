characters = { :Cloud => 'sword',
               :Aeris => 'quarterstaff',
               :Barret => 'gun-arm',
               :Tifa => 'fists',
               :Cid => 'spear' 
             }
             
# accessing elements 
characters[:Cloud] #=> 'sword' 
characters.keys #=> [:Cloud, :Aeris, :Barret, :Tifa, :Cid]

# iteration
characters.each do |key, value| 
  puts "#{key} uses a weapon type of #{value}"
end
#=> Cloud uses a weapon type of sword
#=> Aeris uses a weapon type of quarterstaff
#=> Barret uses a weapon type of gun-arm
#=> Tifa uses a weapon type of fists
#=> Cid uses a weapon type of spear

# inspecting hashes
characters.has_key? :Cloud #=> true
characters.has_value? 'fists' #=> true

# add or change an element
characters[:Vincent] = 'gun'
characters #=> {:Cloud=>"sword", :Aeris=>"quarterstaff", :Barret=>"gun-arm", :Tifa=>"fists", :Cid=>"spear", :Vincent=>"gun"} 

#delete an element
characters.delete :Vincent #=> 'gun'
characters #=> {:Cloud=>"sword", :Aeris=>"quarterstaff", :Barret=>"gun-arm", :Tifa=>"fists", :Cid=>"spear"}      



