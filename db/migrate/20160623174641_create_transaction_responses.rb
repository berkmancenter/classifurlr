class CreateTransactionResponses < ActiveRecord::Migration
  def change
    create_table :transaction_responses do |t|
      t.integer :status_code
      t.text :raw_results
      t.string :errors_encountered

      t.timestamps null: false
    end
  end
end
