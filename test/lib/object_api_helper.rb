module ObjectApiHelper
  
  def get_game_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/games/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['gameId']
  end #end def
  
  def get_company_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/companies/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['companyId']
  end #end def
  
  def get_feature_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/features/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['featureId']
  end #end def
  
  def get_genre_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/genres/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['genreId']
  end #end def
  
  def get_hardware_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/hardware/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['hardwareId']
  end #end def
  
  def get_release_ids_by_legacy_id(legacy_id)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/releases/legacyId/#{legacy_id}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    ids_array = []
    data['data'].each do |d|
      ids_array << d['releaseId']
    end
    ids_array
  end #end def
  
  def get_me3_uk_id
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/releases/legacyId/110694"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['data'].each do |d|
      if d['metadata']['region'] == "UK"; return d['releaseId']; end
    end
  end #end def
  
end