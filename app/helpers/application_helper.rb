module ApplicationHelper
  
  include Pagy::Frontend

  def show_department_name(resource)
      resource.department.display_name
  end

  def show_data_type_name(resource)
    if resource.data_type
      resource.data_type.display_name
    else
      "No data type has been selected"
    end
  end

  def show_it_security_incident_status(resource)
    if resource.it_security_incident_status
      resource.it_security_incident_status.name
    else
      "No status has been selected"
    end
  end

  def show_dpa_exception_status(resource)
    if resource.dpa_exception_status
      resource.dpa_exception_status.name
    else
      "No status has been selected"
    end
  end

  def show_device(resource)
    if resource.device
      resource.device.display_name
    else
      ""
    end
  end

  def show_storage_location(resource)
    if resource.storage_location
      resource.storage_location.display_name
    else
      "No storage location has been selected"
    end
  end

  def show_date(field)
    field.strftime("%m/%d/%Y") unless field.blank?
  end

  def user_name_email(id)
    User.find(id).display_name
  end

end
