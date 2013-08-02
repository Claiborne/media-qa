module StatusHelper
  
  GREEN = {:color => 'green', :icon => 'w'}
  ORANGE = {:color => 'orange', :icon => 'e'}
  RED = {:color => 'red', :icon => 'e'}
  HOMEPAGE_ERROR_MSG = {:message => "The homepage is down"}
  BACKEND_ERROR_MSG = {:message => "The backend of this system is down"}
  
  ARTICLE_API = 'http://apis.lan.ign.com/article/v3/ping'
  SLOTTER_API = 'http://apis.lan.ign.com/slotter/v3/slotters'
  VIDEO_API = 'http://apis.lan.ign.com/video/v3/ping'
  IMAGE_API = 'http://apis.lan.ign.com/image/v3/ping'
  OBJECT_API = 'http://apis.lan.ign.com/object/v3/ping'

  def check_ign
    ign = Status.find_by_system "IGN.com"
    message = {:message => ign[:message]} 
    if ign[:custom].to_s == 'true'
      case ign[:status]
      when 'green'
        raise RuntimeException
      when 'orange'
        return ORANGE.merge message
      when 'red'
        return RED.merge message  
      else
        return ORANGE.merge message
      end
    else
      begin
        response = RestClient.get 'http://www.ign.com'
      rescue => e
        e.response.code
        return RED.merge HOMEPAGE_ERROR_MSG
      end
      return GREEN if response.code == 200
      RED.merge HOMEPAGE_ERROR_MSG
    end
  end

  def check_pingable(url)
    begin
      response = RestClient.get url  
    rescue => e
     return RED.merge BACKEND_ERROR_MSG 
    end
    return GREEN if response.to_s.match /pong/
    RED.merge BACKEND_ERROR_MSG
  end

  def check_slotter(url)
    begin
      response = RestClient.get url  
    rescue => e
     return RED.merge BACKEND_ERROR_MSG 
    end
    return GREEN if response.to_s.length > 10000 && response.code < 400
    RED.merge BACKEND_ERROR_MSG
  end
  
end
