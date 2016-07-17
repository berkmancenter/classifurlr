class AddClassificationToClassifiers < ActiveRecord::Migration
  def change
    add_reference :classifiers, :classification, index: true, foreign_key: true
  end
end
