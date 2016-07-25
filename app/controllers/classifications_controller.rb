class ClassificationsController < ApplicationController
  def index
    @classifactions = Classification.all
  end

  def show
    @classifaction = Classification.find params[ :id ]
  end

  # create a Classification with the supplied transaction_data
  def create
    @classifaction = Classification.new transaction_data: params[ :data ]
    @classifaction.classifiers << StatusCodeClassifier.classify( @classifaction.transaction_data )
    @classifaction.classify

    if @classifaction.save
      render json: @classifaction, status: :created
    else
      render json: { error: 'oops' }.to_json, status: 500
    end
  end
end
