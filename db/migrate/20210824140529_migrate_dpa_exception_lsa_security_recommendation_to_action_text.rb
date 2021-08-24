class MigrateDpaExceptionLsaSecurityRecommendationToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :dpa_exceptions, :lsa_security_recommendation, :lsa_security_recommendation_old
    DpaException.all.each do |dpa|
      dpa.update_attribute(:lsa_security_recommendation, simple_format(dpa.lsa_security_recommendation_old))
    end
    remove_column :dpa_exceptions, :lsa_security_recommendation_old
  end
end
