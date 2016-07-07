class CreateTransactionRequests < ActiveRecord::Migration
  def change
    create_table :transaction_requests do |t|
      t.integer :timeout
      t.string :request_headers
      t.string :asn

      t.timestamps null: false
    end
  end
end
