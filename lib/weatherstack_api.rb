class WeatherstackApi
  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}"

    response = HTTParty.get "#{url}&query=#{ERB::Util.url_encode(city)}"
    Weather.new(response.parsed_response["current"])
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
