class ClassificationsController < ApplicationController
  def show
    @classifaction = Classification.find params[ :id ]
  end

  def create
    @classifaction = Classification.new

    if @classifaction.save
      render json: @classifaction, status: :created
    end
  end
end
