# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                                                 :bigint           not null, primary key
#  review_date_exception_first_approval_date          :datetime
#  third_party_product_service                        :text(65535)      not null
#  used_by                                            :string(255)
#  point_of_contact                                   :string(255)
#  review_findings                                    :text(65535)
#  review_summary                                     :text(65535)
#  lsa_security_recommendation                        :text(65535)
#  lsa_security_determination                         :text(65535)
#  lsa_security_approval                              :string(255)
#  lsa_technology_services_approval                   :string(255)
#  exception_approval_date_exception_renewal_date_due :datetime
#  notes                                              :string(255)
#  sla_agreement                                      :string(255)
#  data_type_id                                       :bigint           not null
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  deleted_at                                         :datetime
#  incomplete                                         :boolean          default(FALSE)
#  review_date_exception_review_date                  :datetime
#
class DpaException < ApplicationRecord
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  has_one_attached :sla_attachment
  audited

  validates :third_party_product_service, presence: true

  validate :validate_if_complete

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

  def validate_if_complete
    if self.review_date_exception_first_approval_date.blank?
      errors.add(:review_date_exception_first_approval_date, "can't be blank") unless self.incomplete 
    end
    if self.exception_approval_date_exception_renewal_date_due.blank?
      errors.add(:exception_approval_date_exception_renewal_date_due, "can't be blank") unless self.incomplete 
    end
    if self.review_date_exception_review_date.blank?
      errors.add(:review_date_exception_review_date, "can't be blank") unless self.incomplete 
    end
    if self.used_by.blank?
      errors.add(:used_by, "can't be blank") unless self.incomplete 
    end
    if self.lsa_security_approval.blank?
      errors.add(:lsa_security_approval, "can't be blank") unless self.incomplete
    end
    if self.lsa_technology_services_approval.blank?
      errors.add(:lsa_technology_services_approval, "can't be blank") unless self.incomplete
    end
  end

end
