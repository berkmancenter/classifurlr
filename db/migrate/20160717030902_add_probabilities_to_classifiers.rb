class AddProbabilitiesToClassifiers < ActiveRecord::Migration
  def change
    add_column :classifiers, :available, :float
    add_column :classifiers, :block_page, :float
  end
end
