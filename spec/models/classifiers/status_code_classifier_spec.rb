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

#  describe 'classify' do
#    let ( :transaction_data ) {
#      {
#        type: 'transactions',
#        attributes: {
#          url: 'http://cyber.law.harvard.edu',
#          responses: [ {
#            statusCode: 0,
#          } ]
#        }
#      }
#    }
#
#    let ( :status_code_classifier ) { StatusCodeClassifier.new }
#
#    context '200 response' do
#      it {
#        transaction_data[ :attributes ][ :responses ][ 0 ][ :statusCode ] = 200
#        expect {
#          status_code_classifier.classify( transaction_data ).to eq( {
#            name: 'status_code_classifier',
#            available: 1.0,
#            weight: 1.0
#          } )
#        }
#      }
#    end
#  end
end
