# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string(255)      default("")
#  remember_created_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  failed_attempts     :integer          default(0), not null
#  unlock_token        :string(255)
#  locked_at           :datetime
#  username            :string(255)      default(""), not null
#
class User < ApplicationRecord
  before_create :set_email_address
  attr_accessor :membership, :dept

  # Include default devise modules. Others available are:
  devise :ldap_authenticatable, :rememberable, :trackable, :timeoutable,
         :lockable

  scope :recent, -> { where("current_sign_in_at > ?", 2.days.ago) }
  
  def display_name
    "#{self.username} - #{email}"
  end

  def display_login_info
    "#{self.username} - #{email} Last logged in at: #{self.current_sign_in_at}"
  end

  private
 
  def set_email_address
   self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail")[0]
  end
end
