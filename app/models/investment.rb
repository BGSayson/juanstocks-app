class Investment < ApplicationRecord
  belongs_to :wallet
  belongs_to :transactions, class_name:"Transaction", optional: true
  monetize :buying_price_cents

  validates :total_share_amount, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def investment_display
    "[ #{self.total_share_amount} Shares ] #{Stock.find(self.stock_id).description}"
  end
end
