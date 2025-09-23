class ChangeInvestmentIdToForeignKeyFromTransaction < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :transactions, :investments, column: :investment_id #primary_key: "id"
  end
end
