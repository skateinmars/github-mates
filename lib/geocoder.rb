class Geocoder
  GOOGLE_ENDPOINT = "http://maps.googleapis.com/"

  class << self
    def geocode(address)
      response = connection.get '/maps/api/geocode/json', { :address => address, :sensor => false }
      
      if response.status == 200
        content = JSON.parse(response.body)
        return content['results'].first['geometry']['location'] unless content['results'].empty?
      end

      {"lat"=>nil, "lng"=>nil}
    end

    private

    def connection
      Faraday.new(:url => GOOGLE_ENDPOINT) do |faraday|
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end