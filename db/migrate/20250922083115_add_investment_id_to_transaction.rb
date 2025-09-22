class AddInvestmentIdToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :investment_id, :integer
  end
end
