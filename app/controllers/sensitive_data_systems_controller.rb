class SensitiveDataSystemsController < InheritedResources::Base

  private

    def sensitive_data_system_params
      params.require(:sensitive_data_system).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :device_id)
    end

end
