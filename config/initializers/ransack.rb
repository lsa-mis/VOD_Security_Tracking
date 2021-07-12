Ransack.configure do |c|
    # Raise errors if a query contains an unknown predicate or attribute.
    # Default is true (do not raise error on unknown conditions).
    c.ignore_unknown_conditions = false
end

Ransack::Enum.configure do |config|
  # enabled
  config.enabled = true

  # disabled
  # config.enabled = false
end
