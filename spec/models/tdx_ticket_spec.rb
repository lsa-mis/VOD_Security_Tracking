# == Schema Information
#
# Table name: tdx_tickets
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  records_to_tdx_type :string(255)      not null
#  records_to_tdx_id   :bigint           not null
#  ticket_link         :string(255)
#
require 'rails_helper'

RSpec.describe TdxTicket, type: :model do
  describe "validations" do
    it "requires a ticket_link" do
      ticket = TdxTicket.new(ticket_link: nil)
      expect(ticket).not_to be_valid
    end

    it "is valid with ticket_link" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      ticket = FactoryBot.build(:tdx_ticket, :for_dpa_exception, records_to_tdx: dpa_exception, ticket_link: "https://example.com/ticket/123")
      expect(ticket).to be_valid
    end
  end

  describe "associations" do
    it "belongs to a polymorphic records_to_tdx" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      ticket = FactoryBot.create(:tdx_ticket, :for_dpa_exception, records_to_tdx: dpa_exception)
      expect(ticket.records_to_tdx).to eq(dpa_exception)
    end

    it "can belong to different record types" do
      incident = FactoryBot.create(:it_security_incident)
      ticket = FactoryBot.create(:tdx_ticket, :for_it_security_incident, records_to_tdx: incident)
      expect(ticket.records_to_tdx).to eq(incident)
    end
  end

  describe "audited" do
    it "has audits" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      ticket = FactoryBot.create(:tdx_ticket, :for_dpa_exception, records_to_tdx: dpa_exception)
      expect(ticket).to respond_to(:audits)
    end
  end
end
