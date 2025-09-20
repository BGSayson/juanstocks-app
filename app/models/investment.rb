class Investment < ApplicationRecord
  belongs_to :wallet
  monetize :buying_price_cents

  has_one :stock

  validates :total_share_amount, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
