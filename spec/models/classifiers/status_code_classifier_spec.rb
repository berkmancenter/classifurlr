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
    context '200 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 200 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 1.0 )
      }
    end

    context '204 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 204 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 1.0 )
      }
    end

    context '400 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 400 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 0.0 )
      }
    end

    context '404 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 404 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 0.0 )
      }
    end

    context '500 response' do
      let ( :transaction_data ) {
        { 'log' => { 'entries' => [ { 'response' => { 'status' => 500 } } ] } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 0.0 )
      }
    end

    context 'missing status in response' do
      let ( :transaction_data ) {
        { 'log' => { } }
      }

      it {
        c = StatusCodeClassifier.classify( transaction_data )
        expect( c.available ).to eq( 0.0 )
      }
    end

    context 'nil transaction_data' do
      it {
        c = StatusCodeClassifier.classify( nil )
        expect( c.available ).to eq( 0.0 )
      }
    end
  end
end
