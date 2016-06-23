class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :url

      t.timestamps null: false
    end
  end
end
