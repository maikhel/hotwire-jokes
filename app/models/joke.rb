class Joke < ApplicationRecord
  PER_PAGE = 9

  belongs_to :jokes_request

  validates :body, presence: true
end
