class Classifier < ActiveRecord::Base
  before_validation( on: :create ) do
    self.name = type.underscore if name.nil?
    self.weight = self.class.default_weight if weight.nil?
  end

  def self.default_weight
    1.0
  end
end
