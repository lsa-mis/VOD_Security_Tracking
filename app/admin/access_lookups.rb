ActiveAdmin.register AccessLookup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :ldap_group, :vod_table, :vod_action
  #
  # or
  #
  # permit_params do
  #   permitted = [:ldap_group, :vod_table, :vod_action]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :ldap_group, as: :select
  filter :vod_table, as: :select
  filter :vod_action, as: :select


  form do |f| # This is a formtastic form builder
    f.semantic_errors # shows errors on :base
    # f.inputs           # builds an input field for every attribute
    f.inputs do
      f.input :ldap_group
      f.input :vod_table
      f.input :vod_action
    end
    f.actions   
  end

  index do 
    selectable_column
    actions
    column :ldap_group
    column :vod_table
    column :vod_action
    column :created_at
    column :updated_at
  end

end
