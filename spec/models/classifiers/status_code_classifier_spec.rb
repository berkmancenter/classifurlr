require 'rails_helper'

RSpec.describe StatusCodeClassifier do
  it { should respond_to( :name, :type, :weight, :available, :block_page ) }

  it {
    expect( StatusCodeClassifier.new.type ).to eq( 'StatusCodeClassifier' )
  }

  it {
    expect( StatusCodeClassifier.create.name ).to eq( 'status_code_classifier' )
  }

  it {
    expect( StatusCodeClassifier.default_weight ).to eq( 0.8 )
  }

  it {
    expect( StatusCodeClassifier.create.weight ).to eq( 0.8 )
  }

  describe 'classify' do
    let ( :transaction_data ) {
      {
        'attributes' => {
          'responses' => [ {
            'statusCode' => 0
          } ]
        }
      }
    }

    context '200 response' do
      it {
        transaction_data[ 'attributes' ][ 'responses' ][ 0 ][ 'statusCode' ] = 200
        c = StatusCodeClassifier.classify( transaction_data )

        expect( c.name ).to eq( 'status_code_classifier' )
        expect( c.weight ).to eq( 0.8 )
        expect( c.available ).to eq( 1.0 )
      }
    end
  end
end
