# == Schema Information
#
# Table name: tdx_tickets
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  records_to_tdx_type :string(255)      not null
#  records_to_tdx_id   :bigint           not null
#  ticket_link         :string(255)
#
class TdxTicket < ApplicationRecord
    belongs_to :records_to_tdx, polymorphic: true
    audited

    validates :ticket_link, presence: true

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "records_to_tdx_id", "records_to_tdx_type", "ticket_link", "updated_at"]
    end
end
