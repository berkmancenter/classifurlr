require 'rails_helper'

RSpec.describe TransactionResponse do
  it { should respond_to( :status_code, :raw_results, :errors_encountered ) }
end

