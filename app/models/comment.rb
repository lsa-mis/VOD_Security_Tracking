class Comment < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :author, polymorphic: true, optional: true

  validates :body, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[body namespace resource_type resource_id author_type author_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[resource author]
  end
end
