class StatusCodeClassifier < Classifier
  def self.default_weight
    0.8
  end

  def self.classify( transaction_data )
    c = StatusCodeClassifier.new available: 0.0

    begin
      transaction_data[ 'log' ][ 'entries' ].each { |entry|
        if entry[ 'response' ][ 'status' ].to_s[0] == '2'
          c.available = 1.0
        end

        break if c.available.present?
      }
    rescue Exception => e
      Rails.logger.debug "[StatusCodeClassifier.classify] #{e.to_s}"
    end

    c
  end
end
