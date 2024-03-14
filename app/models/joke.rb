class Joke < ApplicationRecord
  include LiveView::JokesObserver

  belongs_to :jokes_request

  validates :body, presence: true
end
