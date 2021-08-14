class DataClassificationLevelsController < ApplicationController

  def get_data_types
    if params[:id] == "0"
      render json: DataType.all
    else
      render json: DataType.where(data_classification_level_id: params[:id])
    end
  end
  
end
