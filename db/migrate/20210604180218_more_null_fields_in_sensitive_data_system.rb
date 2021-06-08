class MoreNullFieldsInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :review_date, :datetime, null: true
    change_column :sensitive_data_systems, :review_contact, :string, null: true
  end
end
