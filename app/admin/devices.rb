ActiveAdmin.register Device do
  menu parent: 'Complementary Tables', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :serial, :hostname, :mac, :building, :room, :owner, :department,
                :manufacturer, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:serial, :hostname, :mac, :building, :room]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show
  scope :incomplete
  scope :all, :default => true

  index do
    selectable_column
    actions
    column "Link to update" do |device|
      link_to device.id, device_path(device)
    end    
    column :serial
    column :hostname
    column :mac
    column :building
    column :room
    column :owner
    column :department
    column :manufacturer
    column :model
  end
  
end
