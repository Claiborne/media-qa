# In Ruby, there is no syntax to explicitly declare a class is abstract

class Fighter # this will be our abstract class
  
  attr_accessor :strength, :speed, :health # shortcut for creating getter and setter methods
  
  def initialize(strength, speed, health)
    @strength, @speed, @health = strength, speed, health # parallel assignment is cool
  end
  
  def attack
    raise NotImplementedError # design to help enforce restriction of this abstract class
  end
  
  def defend 
    raise NotImplementedError
  end
  
  def move
    "Watch out. I am moving!"
  end
  
end

class Karateman < Fighter # syntax for declaring parent. can only have one
  
  def attack # implementing abstract attack method
    "I attack with my fists!!!!!!"
  end
  
  def defend
    "I defend by evading"  
  end
  
  def move
    super+" And I move so fast!"
  end
  
end

k = Karateman.new 100, 200, 300
k.strength #=> 100
k.speed #=> 200
k.health #=> 300
k.attack #=> 
k.defend #=> 
k.move #=> Watch out. I am moving! And I move so fast