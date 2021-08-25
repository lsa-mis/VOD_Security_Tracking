class MigrateDpaExceptionReviewSummaryToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :dpa_exceptions, :review_summary, :review_summary_old
    DpaException.all.each do |dpa|
      dpa.update_attribute(:review_summary, simple_format(dpa.review_summary_old))
    end
    remove_column :dpa_exceptions, :review_summary_old
  end
end
