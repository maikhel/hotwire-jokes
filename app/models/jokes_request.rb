class JokesRequest < ApplicationRecord
  has_many :jokes, dependent: :destroy
end
