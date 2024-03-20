class JokesController < ApplicationController

  def index; end

  def fetch_joke
    @joke = FetchJokeService.new.call
  end
end
