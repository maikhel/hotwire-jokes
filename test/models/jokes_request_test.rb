require "test_helper"

class JokesRequestTest < ActiveSupport::TestCase
  test "has many jokes" do
    request = jokes_requests(:one)
    joke = Joke.new(body: "funny joke", jokes_request: request)
    another_joke = Joke.new(body: "another funny joke", jokes_request: request)

    assert request.jokes, [ joke, another_joke ]
  end
end
