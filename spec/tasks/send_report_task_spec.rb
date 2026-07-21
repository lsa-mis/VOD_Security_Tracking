require "rails_helper"
require "rake"

RSpec.describe "send_report rake task" do
  before(:all) do
    Rails.application.load_tasks
  end

  before do
    Rake::Task["send_report"].reenable
    ActionMailer::Base.deliveries.clear
  end

  it "delivers the automated report email" do
    Rake::Task["send_report"].invoke

    expect(ActionMailer::Base.deliveries).not_to be_empty
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq(["lsats-vod-support@umich.edu"])
    expect(mail.subject).to eq("VOD: automated report")
  end
end
