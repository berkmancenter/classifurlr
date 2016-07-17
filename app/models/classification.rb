class Classification < ActiveRecord::Base
  has_many :classifiers

  @@available_threshold = 1.0

  def self.available_threshold
    @@available_threshold
  end

  def self.available_threshold=( val )
    @@available_threshold = val
  end

  # given all current classifier values and weights
  # detmine a final value for status, available, and block_page
  def classify
    Rails.logger.debug "Classification #{id}.classify"
    weights_sum = classifiers.map( &:weight ).reduce( 0, :+ )
    Rails.logger.debug "weights_sum: #{weights_sum}"

    available_sum = classifiers.reduce( 0.0 ) { |sum, c|
      true_weight = weights_sum / c.weight
      Rails.logger.debug "#{c.name} true_weight: #{true_weight}"

      sum += c.available * true_weight
    }

    Rails.logger.debug "available_sum: #{available_sum}"
    self.available = available_sum / classifiers.length
    Rails.logger.debug "available: #{available}"

    if available >= @@available_threshold
      self.status = 'up'
    else
      self.status = 'down'
    end
  end

end
