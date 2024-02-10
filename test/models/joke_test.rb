require "test_helper"

class JokeTest < ActiveSupport::TestCase
  test "is invalid without body" do
    joke = Joke.new
    assert_not joke.save, "Saved the joke without a body"
  end
end
