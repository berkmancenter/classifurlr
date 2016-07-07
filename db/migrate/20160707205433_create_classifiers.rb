class CreateClassifiers < ActiveRecord::Migration
  def change
    create_table :classifiers do |t|
      t.string :name
      t.float :available
      t.float :blocked
      t.float :weight

      t.timestamps null: false
    end
  end
end
