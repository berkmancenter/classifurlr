class AddClassifiesToClassifiers < ActiveRecord::Migration
  def change
    add_column :classifiers, :classifies, :string
    remove_column :classifiers, :available, :float
    remove_column :classifiers, :blocked, :float
  end
end
