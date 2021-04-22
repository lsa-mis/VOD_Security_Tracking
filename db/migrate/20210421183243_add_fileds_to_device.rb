class AddFiledsToDevice < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :owner, :string
    add_column :devices, :department, :string
    add_column :devices, :manufacturer, :string
    add_column :devices, :model, :string
  end
end
