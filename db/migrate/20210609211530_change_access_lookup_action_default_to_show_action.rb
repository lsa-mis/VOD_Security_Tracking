class ChangeAccessLookupActionDefaultToShowAction < ActiveRecord::Migration[6.1]
  def change
    remove_column :access_lookups, :action
    add_column :access_lookups, :action, :integer, default: 0, null: false
  end
end
