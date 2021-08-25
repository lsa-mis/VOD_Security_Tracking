class MigrateDpaExceptionLsaSecurityDeterminationToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :dpa_exceptions, :lsa_security_determination, :lsa_security_determination_old
    DpaException.all.each do |dpa|
      dpa.update_attribute(:lsa_security_determination, simple_format(dpa.lsa_security_determination_old))
    end
    remove_column :dpa_exceptions, :lsa_security_determination_old
  end
end
