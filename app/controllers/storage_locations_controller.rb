class StorageLocationsController < ApplicationController

  def is_device_required?
    render json: StorageLocation.find(params[:id]).device_is_required
  end
  
end
