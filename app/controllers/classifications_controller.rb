class ClassificationsController < ApplicationController
  def show
    @classifaction = Classification.find params[ :id ]
  end

  def create
    Rails.logger.info params[ :data ]
    @classifaction = Classification.new

    if @classifaction.save
      render json: @classifaction, status: :created
    else
      render json: { error: 'oops' }.to_json, status: 500
    end
  end
end
