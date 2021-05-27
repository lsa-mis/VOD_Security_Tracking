# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  people_involved                :text(65535)      not null
#  equipment_involved             :text(65535)      not null
#  remediation_steps              :text(65535)      not null
#  estimated_finacial_cost        :integer
#  notes                          :text(65535)
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
#
class ItSecurityIncident < ApplicationRecord
  has_one :it_security_incident_status
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  audited

  validate :validate_if_complete
  validates :people_involved, presence: true
  validates :equipment_involved, presence: true
  validates :remediation_steps, presence: true
  validates :data_type_id, presence: true


  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

  def validate_if_complete
    if self.it_security_incident_status_id.blank?
      errors.add(:it_security_incident_status_id, "can't be blank") unless self.incomplete 
    end
    if self.date.blank?
      errors.add(:date, "can't be blank") unless self.incomplete
    end
  end
  
end
