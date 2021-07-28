# == Schema Information
#
# Table name: application_settings
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ApplicationSetting < ApplicationRecord
    has_rich_text :content
end
