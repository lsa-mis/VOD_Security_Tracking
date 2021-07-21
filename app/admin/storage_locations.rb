ActiveAdmin.register StorageLocation do
  menu parent: 'Complementary Tables', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :description_link, :device_is_required
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :description_link]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
