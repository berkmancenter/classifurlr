class StatusCodeClassifier < Classifier
  def self.default_weight
    0.8
  end

  def self.classify( transaction_data )
    Rails.logger.debug "StatusCodeClassifier.classify transaction_data.class: #{transaction_data.class}, data: #{transaction_data}"

    c = StatusCodeClassifier.new

    transaction_data[ 'attributes' ][ 'responses' ].each { |r|
      Rails.logger.debug "transaction_response: #{r}"

      case r[ 'statusCode' ].to_i
      when 200
        c.available = 1.0
      end

      break if c.available.present?
    }

    c
  end
end
