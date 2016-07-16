class Classifier < ActiveRecord::Base
  before_validation( on: :create ) do
    self.name = type.underscore
  end
end
