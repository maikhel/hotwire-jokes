class Joke < ApplicationRecord
  belongs_to :jokes_request

  validates :body, presence: true

  broadcasts_to ->(joke) { [ joke.jokes_request, "jokes" ] }, inserts_by: :append
end
