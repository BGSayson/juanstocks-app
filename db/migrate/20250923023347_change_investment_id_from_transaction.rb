class ChangeInvestmentIdFromTransaction < ActiveRecord::Migration[8.0]
  def change
    remove_column :transactions, :investment_id
    add_column :transactions, :investment_id, :integer
    add_foreign_key :transactions, :investments, column: :investment_id, on_delete: :nullify #primary_key: "id"
  end
end
