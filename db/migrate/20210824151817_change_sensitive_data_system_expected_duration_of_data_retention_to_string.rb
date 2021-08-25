class ChangeSensitiveDataSystemExpectedDurationOfDataRetentionToString < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :expected_duration_of_data_retention, :string
  end
end
