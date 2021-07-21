# == Schema Information
#
# Table name: application_settings
#
#  id                :bigint           not null, primary key
#  page              :string(255)
#  description       :string(255)
#  index_description :text(65535)
#  form_instruction  :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class ApplicationSetting < ApplicationRecord
end
