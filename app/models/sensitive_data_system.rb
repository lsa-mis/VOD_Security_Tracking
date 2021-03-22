# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)
#  owner_full_name                     :string(255)
#  dept                                :string(255)
#  phone                               :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)
#  expected_duration_of_data_retention :text(65535)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime
#  review_contact                      :string(255)
#  notes                               :string(255)
#  storage_location_id                 :bigint           not null
#  data_type_id                        :bigint           not null
#  device_id                           :bigint           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
class SensitiveDataSystem < ApplicationRecord
  belongs_to :storage_location
  belongs_to :data_type
  belongs_to :device
  has_many :tdx_tickets, as: :records_to_tdx

  has_many_attached :attachments

end
