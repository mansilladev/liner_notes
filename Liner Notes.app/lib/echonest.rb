require 'open-uri'
require 'json'

class Echonest
  URL = 'http://developer.echonest.com/api/v4'
  include Cache

  def initialize(key='KT7FDAYYNP4OGOMSI')
    @credentials = "api_key=#{key}&format=json"
  end

  def images(artist)
    resource = 'artist/images'
    clean_artist = URI.encode(artist)
    query = "results=10&name=#{clean_artist}"

    if result = get(resource, query)
      result['images'].map{ |f| f['url'] }
    else
      nil
    end
  end

  def get(resource, query)
    key = "#{resource}-#{query}"
    if cached = fetch_cached(key)
      return JSON.parse(cached)['response']
    end

    final_url = "#{URL}/#{resource}?#{@credentials}&#{query}"
    LinerNotes.logger.debug final_url
    LinerNotes.logger.debug "Starting Echonest request"
    raw = Http.get(final_url)
    LinerNotes.logger.debug "Finished Echonest request"

    json = JSON.load(raw)
    if json['response']['status']['code'].to_i == 0
      cache!(raw, key)
      json['response']
    else
      LinerNotes.logger.error "Echonest error: #{json['response']['status']['message']}"
    end
  end

end
