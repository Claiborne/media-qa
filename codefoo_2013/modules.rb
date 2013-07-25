module Spellcast # define a module
  
  def cast_lightning
    'ZOMG LIGHTNING TO YOUR FACE!'
  end
  
end

class Mage
  
  include Spellcast # include as many module as you need
  
end

class Wizard
  
  include Spellcast
  
end

# as you can see, modules are great for defining roles
# Spellcast module definies a spellcaster role. Mage and Wizard are natural spellcasters

Mage.new.cast_lightning #=> 'ZOMG LIGHTNING TO YOUR FACE!'
Wizard.new.cast_lightning #=> 'ZOMG LIGHTNING TO YOUR FACE!'