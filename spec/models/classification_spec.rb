require 'rails_helper'

RSpec.describe Classification do
  let ( :transaction_data ) {
    {
      attributes: {
        responses: [ {
          statusCode: 200
        } ]
      }
    }
  }

  it { should respond_to( :transaction_data, :status, :available, :block_page ) }

  it { should respond_to( :classifiers ) }

  it { should respond_to( :classify ) }

  it {
    expect( Classification.available_threshold ).to eq( 0.8 )
  }

  it ( 'stores transaction_data' ) {
    expect( Classification.new( transaction_data: transaction_data ).transaction_data ).to eq( transaction_data.as_json )
  }

  it ( 'stores classifiers' ) {
    c = Classification.new
    c.classifiers << StatusCodeClassifier.new
    
    expect {
      c.save
    }.to change { c.classifiers.count }.by( 1 )
  }

  it ('can classify' ) {
    c = Classification.new
    c.classifiers << StatusCodeClassifier.classify( transaction_data )
    c.classify
    
    expect( c.available ).to eq( 1.0 )
    expect( c.status ).to eq( 'up' )
  }
end

