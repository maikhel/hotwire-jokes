require "net/http"
require "json"

class FetchJokesService
  API_ENDPOINT = "https://api.chucknorris.io/jokes/random".freeze

  def initialize(jokes_request_id)
    @jokes_request = JokesRequest.find(jokes_request_id)
  end

  def call
    jokes = []
    @jokes_request.amount.times do
      response = make_request
      joke = parse_response(response)

      @jokes_request.jokes.create(body: joke)
    end

    true
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
