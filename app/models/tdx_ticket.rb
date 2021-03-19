# == Schema Information
#
# Table name: tdx_tickets
#
#  id                  :bigint           not null, primary key
#  ticket_number       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  records_to_tdx_type :string(255)      not null
#  records_to_tdx_id   :bigint           not null
#
class TdxTicket < ApplicationRecord
    belongs_to :records_to_tdx, polymorphic: true
end
