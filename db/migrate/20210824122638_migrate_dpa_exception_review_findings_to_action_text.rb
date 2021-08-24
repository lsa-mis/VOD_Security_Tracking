class MigrateDpaExceptionReviewFindingsToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :dpa_exceptions, :review_findings, :review_findings_old
    DpaException.all.each do |dpa|
      dpa.update_attribute(:review_findings, simple_format(dpa.review_findings_old))
    end
    remove_column :dpa_exceptions, :review_findings_old
  end
end
