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
class SensitiveDataSystemType < ApplicationRecord
    has_many :sensitive_data_systems
end
