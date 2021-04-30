# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                               :bigint           not null, primary key
#  review_date                      :datetime         not null
#  third_party_product_service      :text(65535)      not null
#  used_by                          :string(255)      not null
#  point_of_contact                 :string(255)
#  review_findings                  :text(65535)
#  review_summary                   :text(65535)
#  lsa_security_recommendation      :text(65535)
#  lsa_security_determination       :text(65535)
#  lsa_security_approval            :string(255)      not null
#  lsa_technology_services_approval :string(255)      not null
#  exception_approval_date          :datetime         not null
#  notes                            :string(255)
#  sla_agreement                    :string(255)
#  data_type_id                     :bigint           not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  deleted_at                       :datetime
#  incomplete                       :boolean          default(FALSE)
#
class DpaException < ApplicationRecord
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  has_one_attached :sla_attachment
  audited

  validates :review_date, presence: true
  validates :third_party_product_service, presence: true
  validates :used_by, presence: true
  validates :lsa_security_approval, presence: true
  validates :lsa_technology_services_approval, presence: true
  validates :exception_approval_date, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end
  
end
