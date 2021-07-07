class AddDeletedAtToDevice < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :deleted_at, :datetime
  end
end
