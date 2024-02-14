class FetchJokesJob < ApplicationJob
  queue_as :default

  def perform(jokes_request_id)
    ::FetchJokesService.new(jokes_request_id).call
  end
end
