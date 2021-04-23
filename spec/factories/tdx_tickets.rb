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
FactoryBot.define do
  factory :tdx_ticket do
    ticket_number { 1 }
  end
end
