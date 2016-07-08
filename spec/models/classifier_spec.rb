require 'rails_helper'

RSpec.describe Classifier do
  it { should respond_to( :name, :classifies, :weight ) }
end

