class DataClassificationLevelsController < ApplicationController

  def get_data_types
    render json: DataType.where(data_classification_level_id: params[:id])
  end
  
end
