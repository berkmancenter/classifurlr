class Classifier < ActiveRecord::Base
  after_initialize do
    self.name = self.class.name.underscore if name.nil?
    self.weight = self.class.default_weight if weight.nil?
  end

  def self.default_weight
    1.0
  end

  def self.classify( transaction_data )
    # implement in subclasses, accept Hash, return instace model
    fail NotImplementedError, 'Classifiers must implement classify'
  end
end
