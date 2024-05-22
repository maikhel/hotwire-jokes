require "net/http"
require "json"

class FetchJokesService
  API_ENDPOINT = "https://api.chucknorris.io/jokes/random".freeze

  def initialize(jokes_request_id)
    @jokes_request = JokesRequest.find(jokes_request_id)
  end

  def call
    jokes = []

    missing_jokes_count.times do |num|
      response = make_request
      joke = parse_response(response)

      @jokes_request.jokes.create(body: joke)
      broadcast_update_to_show_page(joke, num + 1)
      sleep(jokes_request.delay) if jokes_request.delay.positive?
    end

    true
  end

  private

  attr_reader :jokes_request

  def broadcast_update_to_show_page(joke, num)
    add_joke(joke, num)
  end

  def add_joke(joke, jokes_count)
    last_page = jokes_count / Joke::PER_PAGE + 1

    if jokes_count % Joke::PER_PAGE ==  1 # change page to next one
      clear_all_jokes
      add_joke_card(joke)
      replace_pagination(jokes_count, last_page)
    else
      add_joke_card(joke)
    end
  end

  def clear_all_jokes
    Turbo::StreamsChannel.broadcast_replace_to(
      [ jokes_request, "jokes" ],
      target: "jokes_grid",
      partial: "jokes_requests/empty_jokes_grid"
    )
  end

  def add_joke_card(joke)
    Turbo::StreamsChannel.broadcast_append_to(
      [ jokes_request, "jokes" ],
      target: "jokes_grid",
      partial: "jokes/joke",
      locals: { joke: joke }
    )
  end

  def replace_pagination(jokes_count, last_page)
    pagy = Pagy.new(count: jokes_count, page: last_page,
              items: Joke::PER_PAGE,
              link_extra: 'data-turbo-action="advance"')

    Turbo::StreamsChannel.broadcast_replace_to(
      [ jokes_request, "jokes_pagination" ],
      target: "jokes_pagination",
      partial: "jokes_requests/jokes_pagination",
      locals: { pagy: pagy }
    )
  end

  def missing_jokes_count
    jokes_request.amount - jokes_request.jokes.size
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
