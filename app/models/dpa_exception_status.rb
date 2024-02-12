# == Schema Information
#
# Table name: dpa_exception_statuses
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DpaExceptionStatus < ApplicationRecord

  has_many :dpa_exception

  validates :name, uniqueness: true, presence: true
  
  def self.ransackable_associations(auth_object = nil)
    ["dpa_exception"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end
  
  def display_name
    "#{self.name}"
  end
end
