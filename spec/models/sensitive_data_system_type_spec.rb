# == Schema Information
#
# Table name: sensitive_data_system_types
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe SensitiveDataSystemType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
