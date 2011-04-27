require 'date'

class CustomTime
  
  def get_int_time
    return Time.now.to_i
  end
  
  def combined_time
    return Time.year + Time.month + Time.day + Time.hour + Time.minute + Time.second
  end
  
end
