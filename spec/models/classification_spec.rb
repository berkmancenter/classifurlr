require 'rails_helper'

RSpec.describe Classification do
  let ( :transaction_data ) {
    {
      type: 'transactions',
      attributes: {
        url: 'http://cyber.law.harvard.edu',
        responses: [ {
          statusCode: 200,
          request: {
            asn: '23650'
          }
        } ]
      }
    }.as_json
  }

  it { should respond_to( :transaction_data, :status, :available, :block_page ) }

  it ( 'saves transaction_data' ) {
    expect( Classification.new( transaction_data: transaction_data ).transaction_data ).to eq( transaction_data )
  }

end

