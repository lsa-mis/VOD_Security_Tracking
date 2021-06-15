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
  belongs_to :it_security_incident_status
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  audited

  validates :date, :people_involved, :equipment_involved, :remediation_steps,
            :data_type_id, :it_security_incident_status_id, presence: true


  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

  def display_name
    "#{self.id}"
  end
  
end
