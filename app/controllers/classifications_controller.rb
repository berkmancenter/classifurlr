class ClassificationsController < ApplicationController
  def index
    @classifactions = Classification.all
  end

  def show
    @classifaction = Classification.find params[ :id ]
  end

  # create a Classification with the supplied har
  def create
    Rails.logger.debug "[ClassificationsController.create] params.class: #{params.class}, params: #{params}"
    @classifaction = Classification.new transaction_data: params
    @classifaction.classifiers << StatusCodeClassifier.classify( @classifaction.transaction_data )
    @classifaction.classify

    if @classifaction.save
      render json: @classifaction.as_jsonapi, status: :created
    else
      render json: { error: 'oops' }, status: 500
    end
  end
end
