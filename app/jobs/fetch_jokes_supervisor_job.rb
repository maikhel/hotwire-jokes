class FetchJokesSupervisorJob < ApplicationJob
  BATCH_SIZE = 25
  queue_as :default

  def perform(jokes_request_id)
    jokes_request = JokesRequest.find(jokes_request_id)
    jokes_to_fetch_count = jokes_request.amount - jokes_request.jokes.size

    (1..jokes_to_fetch_count).each_slice(BATCH_SIZE) do |slice|
      FetchJokesJob.perform_later(jokes_request_id, slice.size)
    end
  end
end
