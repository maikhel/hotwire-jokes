class Joke < ApplicationRecord
  belongs_to :jokes_request

  validates :body, presence: true

  after_create_commit ->(joke) do
    broadcast_replace_to([ joke.jokes_request, "jokes_count" ], target: "jokes_count", partial: "jokes_requests/jokes_count", locals: { jokes_request: joke.jokes_request })
    broadcast_append_to([ joke.jokes_request, "jokes" ], target: "jokes_grid", partial: "jokes/joke", locals: { joke: joke })
  end
end
