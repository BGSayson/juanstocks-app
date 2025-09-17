class RemoveWalletIdFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :wallet_id, :integer
  end
end
