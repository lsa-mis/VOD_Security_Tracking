require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe "#send_report" do
    let(:result) do
      [{
        "table" => "dpa_exceptions",
        "total" => 5,
        "header" => ["ID", "Status", "Service"],
        "rows" => [["1", "Active", "Test Service"]]
      }]
    end
    let(:mail) { ReportMailer.send_report(result) }

    it "sends email to correct recipient" do
      expect(mail.to).to eq(["lsats-vod-support@umich.edu"])
    end

    it "has correct subject" do
      expect(mail.subject).to eq("VOD: automated report")
    end

    it "assigns result to instance variable" do
      expect(mail.body.encoded).to be_present
    end
  end
end
