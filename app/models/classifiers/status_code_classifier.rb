class StatusCodeClassifier < Classifier
  def self.default_weight
    0.8
  end

  def self.classify( transaction_data )
    c = StatusCodeClassifier.new

    transaction_data[ :attributes ][ :responses ].each { |r|

      case r[ :statusCode ]
      when 200
        c.available = 1.0
      end

      break if c.available.present?
    }

    c
  end
end
