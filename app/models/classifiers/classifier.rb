class Classifier < ActiveRecord::Base
  before_validation( on: :create ) do
    self.name = type.underscore if name.nil?
    self.weight = 1.0 if weight.nil?
  end
end
