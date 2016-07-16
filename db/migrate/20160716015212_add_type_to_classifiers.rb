class AddTypeToClassifiers < ActiveRecord::Migration
  def change
    add_column :classifiers, :type, :string
    remove_column :classifiers, :classifies, :string
  end
end
