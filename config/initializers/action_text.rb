ActiveSupport.on_load(:action_text_rich_text) do
  class ActionText::RichText < ActionText::Record
    def self.ransackable_attributes(auth_object = nil)
      ["body", "created_at", "id", "name", "record_id", "record_type", "updated_at"]
    end
  end
end