require "test_helper"

class FetchJokesSupervisorJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should invoke one service if number of jokes < BATCH_SIZE" do
    @jokes_request = JokesRequest.create(amount: 20, delay: 0)

    assert_enqueued_jobs 1, only: FetchJokesJob do
      FetchJokesSupervisorJob.new(@jokes_request.id).perform_now
    end

    assert [ @jokes_request.id, 20 ], enqueued_jobs[0]["arguments"]
  end

  test "should invoke more service if number of jokes > BATCH_SIZE" do
    @jokes_request = JokesRequest.create(amount: 65, delay: 0)

    assert_enqueued_jobs 3, only: FetchJokesJob do
      FetchJokesSupervisorJob.new(@jokes_request.id).perform_now
    end

    assert [ @jokes_request.id, 25 ], enqueued_jobs[0]["arguments"]
    assert [ @jokes_request.id, 25 ], enqueued_jobs[1]["arguments"]
    assert [ @jokes_request.id, 15 ], enqueued_jobs[2]["arguments"]
  end
end
