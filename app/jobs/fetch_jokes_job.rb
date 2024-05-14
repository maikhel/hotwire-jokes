class FetchJokesJob < ApplicationJob
  queue_as :default

  def perform(jokes_request_id, jokes_count)
    ::FetchJokesService.new(jokes_request_id).perform(jokes_count)
  end
end
