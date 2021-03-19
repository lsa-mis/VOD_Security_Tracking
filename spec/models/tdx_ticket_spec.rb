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
require 'rails_helper'

RSpec.describe TdxTicket, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
