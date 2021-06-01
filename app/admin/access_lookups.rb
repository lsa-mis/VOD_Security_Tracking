ActiveAdmin.register AccessLookup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :ldap_group, :table, :action
  #
  # or
  #
  # permit_params do
  #   permitted = [:ldap_group, :table, :action]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form do |f| # This is a formtastic form builder
    f.semantic_errors # shows errors on :base
    # f.inputs           # builds an input field for every attribute
    f.inputs do
      f.input :ldap_group
      f.input :table, as: :select, collection: AccessLookup.tables
      f.input :action, as: :select, collection: AccessLookup.actions
    end
    f.actions 
  end

end
