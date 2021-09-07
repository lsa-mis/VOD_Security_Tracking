class AvailabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    all_notes = Notification.where.not(id: [record])
    date_ranges = all_notes.map { |b| b.opendate..b.closedate }

    date_ranges.each do |range|
      if range.cover? value
        record.errors.add(attribute, "not available")
      end
    end
  end
end