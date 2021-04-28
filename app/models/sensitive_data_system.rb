# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)
#  dept                                :string(255)
#  phone                               :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)      not null
#  expected_duration_of_data_retention :text(65535)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime         not null
#  review_contact                      :string(255)      not null
#  notes                               :string(255)
#  storage_location_id                 :bigint           not null
#  data_type_id                        :bigint           not null
#  device_id                           :bigint           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#
class SensitiveDataSystem < ApplicationRecord
  belongs_to :storage_location
  belongs_to :data_type
  belongs_to :device
  has_many :tdx_tickets, as: :records_to_tdx

  has_many_attached :attachments
  audited

  validates :owner_username, presence: true
  validates :support_poc, presence: true
  validates :review_date, presence: true
  validates :review_contact, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

end
