# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  username               :string(255)      default(""), not null
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#
class User < ApplicationRecord
  enum role: [:user, :visitor, :can_delete]
  after_initialize :set_default_role, :if => :new_record?
  before_create :set_email_address

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :timeoutable, :lockable

  private
 
  def set_email_address
   self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail")
   logger.debug "******** #{Devise::LDAP::Adapter.get_ldap_param(self.username,'memberOf')} *******"
  end
end
