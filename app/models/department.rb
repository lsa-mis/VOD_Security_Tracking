# == Schema Information
#
# Table name: departments
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  shortname        :string(255)
#  active_dir_group :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Department < ApplicationRecord
    has_many :legacy_os_records

  def display_name
    "#{self.name}"
  end
end