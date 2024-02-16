class Joke < ApplicationRecord
  belongs_to :jokes_request

  validates :body, presence: true

  broadcasts_to ->(joke) { [ joke.jokes_request, "jokes" ] }, inserts_by: :append

  after_create_commit ->(joke) { broadcast_replace_to([ joke.jokes_request, "jokes_count" ], target: "jokes_count", partial: "jokes_requests/jokes_count", locals: { jokes_request: joke.jokes_request }) }
end
