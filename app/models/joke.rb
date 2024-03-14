class Joke < ApplicationRecord
  belongs_to :jokes_request

  validates :body, presence: true
end
