require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:department) { FactoryBot.create(:department) }

  describe "validations" do
    it "is valid with a body and resource" do
      comment = described_class.new(body: "Admin note", resource: department)
      expect(comment).to be_valid
    end

    it "requires a body" do
      comment = described_class.new(body: "", resource: department)
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end

    it "requires a resource" do
      comment = described_class.new(body: "Admin note")
      expect(comment).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a polymorphic resource" do
      comment = described_class.create!(body: "Note", resource: department)
      expect(comment.resource).to eq(department)
      expect(comment.resource_type).to eq("Department")
    end

    it "optionally belongs to an author" do
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@example.com"])
      user = FactoryBot.create(:user)
      comment = described_class.create!(body: "Note", resource: department, author: user)
      expect(comment.author).to eq(user)
    end
  end

  describe ".ransackable_attributes" do
    it "includes searchable fields" do
      expect(described_class.ransackable_attributes).to include("body", "resource_type", "namespace")
    end
  end
end
