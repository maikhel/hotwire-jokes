require "test_helper"

class FetchJokesServiceTest < ActiveSupport::TestCase
  def setup
    @jokes_request = JokesRequest.create(amount: 3, delay: 0)
  end

  test "should fetch jokes and save them as Joke objects" do
    stub_request(:get, FetchJokesService::API_ENDPOINT)
      .to_return(status: 200, body: { value: "Chuck Norris can divide by zero." }.to_json)

    assert FetchJokesService.new(@jokes_request.id).call, true

    assert_equal 3, @jokes_request.jokes.count
    @jokes_request.jokes.each do |joke|
      assert_equal "Chuck Norris can divide by zero.", joke.body
    end
  end

  test "should handle JSON response error gracefully" do
    stub_request(:get, FetchJokesService::API_ENDPOINT)
      .to_return(status: 200, body: "invalid json")

    assert FetchJokesService.new(@jokes_request.id).call, true

    assert_equal 0, @jokes_request.jokes.count
  end

  test "should handle HTTP error gracefully" do
    stub_request(:get, FetchJokesService::API_ENDPOINT)
      .to_return(status: 422, body: { message: "Unauthorized" }.to_json)

    assert FetchJokesService.new(@jokes_request.id).call, true

    assert_equal 0, @jokes_request.jokes.count
  end
end
