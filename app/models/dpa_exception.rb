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
#  notes                                              :text(65535)
#  sla_agreement                                      :string(255)
#  data_type_id                                       :bigint
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  deleted_at                                         :datetime
#  incomplete                                         :boolean          default(FALSE)
#  review_date_exception_review_date                  :datetime
#  dpa_status                                         :string(255)      default("in_process"), not null
#
class DpaException < ApplicationRecord
  belongs_to :data_type, optional: true
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  has_one_attached :sla_attachment
  before_save :if_not_complete

  audited

  enum dpa_status: { in_process: "in_process", approved: "approved", denied: "denied", not_pursued: "not_pursued" }

  validates :review_date_exception_first_approval_date, :third_party_product_service,
            :used_by, presence: true
  validates :dpa_status, presence: true
  validate :acceptable_attachments
  validate :acceptable_sla_attachment

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

  def acceptable_attachments
    return unless attachments.attached?
  
    acceptable_types = [
      "application/pdf", "text/plain" "image/jpg", 
      "image/jpeg", "image/png", 
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.apple.pages",
      "application/vnd.apple.numbers",
      "application/x-tar"
    ]

    attachments.each do |att|
      unless att.byte_size <= 20.megabyte
        errors.add(:attachments, "is too big")
      end

      unless acceptable_types.include?(att.content_type)
        errors.add(:attachments, "must be an acceptable file type")
      end
    end
  end

  def acceptable_sla_attachment
    return unless sla_attachment.attached?
  
    acceptable_types = [
      "application/pdf", "text/plain" "image/jpg", 
      "image/jpeg", "image/png", 
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.apple.pages",
      "application/vnd.apple.numbers",
      "application/x-tar"
    ]

    unless sla_attachment.byte_size <= 20.megabyte
      errors.add(:sla_attachment, "is too big")
    end

    unless acceptable_types.include?(sla_attachment.content_type)
      errors.add(:sla_attachment, "must be an acceptable file type")
    end

  end

  def if_not_complete
    if self.not_completed?
      self.incomplete = true
    else
      self.incomplete = false
    end
  end

  def not_completed?
    self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete").all? {|k, v| v.present?} ? false : true
  end

  def display_name
    "#{self.third_party_product_service}"
  end

end
