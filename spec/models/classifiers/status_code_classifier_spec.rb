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
    context 'transaction_data' do
      let ( :transaction_data ) {
        { 'log' => { } }
      }

      skip ( 'should require url in transaction_data' ) {
        expect( StatusCodeClassifier.classify( transaction_data ) ).to_not be_valid
      }
    end

    context '200 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 200 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )

        expect( c.name ).to eq( 'status_code_classifier' )
        expect( c.weight ).to eq( 0.8 )
        expect( c.available ).to eq( 1.0 )
      }
    end
  end
end
