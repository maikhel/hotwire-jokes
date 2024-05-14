require "net/http"
require "json"

class FetchJokesService
  API_ENDPOINT = "https://api.chucknorris.io/jokes/random".freeze

  def initialize(jokes_request_id)
    @jokes_request = JokesRequest.find(jokes_request_id)
  end

  def perform(missing_jokes_count)
    jokes = []

    missing_jokes_count.times do |num|
      response = make_request
      joke = parse_response(response)

      @jokes_request.jokes.create(body: joke)
      broadcast_update_to_show_page(joke)
      sleep(jokes_request.delay) if jokes_request.delay.positive?
    end

    true
  end

  private

  attr_reader :jokes_request

  def broadcast_update_to_show_page(joke)
    Turbo::StreamsChannel.broadcast_append_to(
      [ jokes_request, "jokes" ],
      target: "hidden_jokes_grid",
      partial: "jokes/joke",
      locals: { joke: joke, extra_style: "hidden" }
    )
  end

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
