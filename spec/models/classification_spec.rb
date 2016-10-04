require 'rails_helper'

RSpec.describe Classification do
  let ( :har_data ) {
    {
      'log' => {
        'entries' => [ {
          'response' => {
            'status' => 200
          }
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

  it ( 'stores har' ) {
    expect( Classification.new( transaction_data: har_data ).transaction_data ).to eq( har_data.as_json )
  }

  it ( 'stores classifiers' ) {
    c = Classification.new
    c.classifiers << StatusCodeClassifier.new
    
    expect {
      c.save
    }.to change { c.classifiers.count }.by( 1 )
  }

  it ( 'can classify' ) {
    c = Classification.new
    c.classifiers << StatusCodeClassifier.classify( har_data )
    c.classify
    
    expect( c.available ).to eq( 1.0 )
    expect( c.status ).to eq( 'up' )
  }

  it { should respond_to( :as_jsonapi ) }

  it ( 'returns jsonapi_hash' ) {
    c = Classification.new
    c.classifiers << StatusCodeClassifier.classify( har_data )
    c.classify
    jsonapi_hash = c.as_jsonapi

    expect( jsonapi_hash[ 'data' ] ).not_to be_nil
    expect( jsonapi_hash[ 'data' ][ 'type' ] ).to eq( 'classifications' )
    expect( jsonapi_hash[ 'data' ][ 'attributes' ] ).not_to be_nil
    expect( jsonapi_hash[ 'data' ][ 'attributes' ][ 'status' ] ).to eq( 'up' )
  }

end

