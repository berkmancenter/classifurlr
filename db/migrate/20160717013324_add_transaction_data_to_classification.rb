class AddTransactionDataToClassification < ActiveRecord::Migration
  def change
    add_column :classifications, :transaction_data, :json
    rename_column :classifications, :blocked, :block_page
  end
end
