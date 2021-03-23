class DevicesController < InheritedResources::Base

  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room)
    end

end
