require 'rails_helper'

RSpec.describe Classifier do
  it { should respond_to( :name, :type, :weight ) }
end

RSpec.describe StatusCodeClassifier do
  it { should respond_to( :name, :type, :weight ) }

  it {
    expect( StatusCodeClassifier.new.type ).to eq( 'StatusCodeClassifier' )
  }

  it {
    expect( StatusCodeClassifier.create.name ).to eq( 'status_code_classifier' )
  }
end
