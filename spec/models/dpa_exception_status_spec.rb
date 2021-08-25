# == Schema Information
#
# Table name: dpa_exception_statuses
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe DpaExceptionStatus, type: :model do

  it "should have a unique name" do
    DpaExceptionStatus.create!(name: 'Open')
    dpa_exception_status = DpaExceptionStatus.new(name: 'Open')
    expect(dpa_exception_status).to_not be_valid
    dpa_exception_status.errors[:name].include?("has already be taken")
  end

  it "is not valid without name" do
    expect(DpaExceptionStatus.new(description: "description")).to_not be_valid
  end

end

#  working test