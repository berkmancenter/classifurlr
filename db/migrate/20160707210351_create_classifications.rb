class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.string :status
      t.float :available
      t.float :blocked

      t.timestamps null: false
    end
  end
end
