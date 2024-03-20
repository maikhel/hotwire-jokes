require "net/http"
require "json"

class FetchJokeService
  API_ENDPOINT = "https://api.chucknorris.io/jokes/random".freeze

  def call
      response = make_request
      sleep Random.rand(0..5)
      parse_response(response)
  end

  private

  def make_request
    uri = URI(API_ENDPOINT)
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      response.body
    else
      Rails.logger.info("[#{self.class.name}] Got unsucessful response with: #{response.body}")
      ""
    end
  end

  def parse_response(response)
    json_data = JSON.parse(response)
    json_data["value"] if json_data.key?("value")
  rescue JSON::ParserError => e
    Rails.logger.info("[#{self.class.name}] Error parsing JSON response: #{e.message}")
    nil
  end
end
