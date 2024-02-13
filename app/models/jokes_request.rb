class JokesRequest < ApplicationRecord
  has_many :jokes, dependent: :destroy

  validates :amount, :numericality => { greater_than: 0, less_than: 100 }
end
