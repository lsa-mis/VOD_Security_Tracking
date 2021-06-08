class UpdateDataTypeIdToAccceptNull < ActiveRecord::Migration[6.1]
  def change
    change_column :dpa_exceptions, :data_type_id, :bigint, null: true
  end
end
