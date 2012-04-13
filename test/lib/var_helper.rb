class VarHelper
  @@helper_var1 = "" 
  @@helper_var2 = "" 
  
  def self.set_helper_var1(v)
    @@helper_var1 = v
  end
  
  def self.return_helper_var1
    @@helper_var1
  end
  
  def self.set_helper_var2(v)
    @@helper_var2 = v
  end
  
  def self.return_helper_var2
    @@helper_var2
  end
  
end