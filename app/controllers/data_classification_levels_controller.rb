class DataClassificationLevelsController < ApplicationController

  def get_data_types
    if params[:id] == "0"
      render json: DataType.all.order(:name)
    else
      render json: DataType.where(data_classification_level_id: params[:id]).order(:name)
    end
  end
  
end
