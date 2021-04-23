class SensitiveDataSystemsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin]
  before_action :authenticate_logged_in!

  def index
    @sensitive_data_systems = SensitiveDataSystem.active
  end

  def archive
    @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    authorize @sensitive_data_system
    @sensitive_data_system.archive
    respond_to do |format|
      format.html { redirect_to sensitive_data_systems_path, notice: 'sensitive data system record was successfully archived.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @sensitive_data_systems = SensitiveDataSystem.all
  end

  private

    def sensitive_data_system_params
      params.require(:sensitive_data_system).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :device_id, attachments: [])
    end

end
