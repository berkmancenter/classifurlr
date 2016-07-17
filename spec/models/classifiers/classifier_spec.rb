require 'rails_helper'

RSpec.describe Classifier do
  it { should respond_to( :name, :type, :weight, :available, :block_page ) }

  it {
    expect( Classifier.default_weight ).to eq( 1.0 )
  }

  it {
    expect {
      Classifier.classify( nil )
    }.to raise_error( NotImplementedError )
  }

end

