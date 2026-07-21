require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  describe "#admin_nav_link" do
    it "marks the active link" do
      html = helper.admin_nav_link("Departments", "/admin/departments", active: true)
      expect(html).to include("Departments")
      expect(html).to include("bg-sky-700")
    end

    it "renders inactive links without the active class" do
      html = helper.admin_nav_link("Users", "/admin/users", active: false)
      expect(html).to include("Users")
      expect(html).not_to include("bg-sky-700 text-white")
    end
  end

  describe "#admin_attr_rows" do
    it "renders attribute labels and values" do
      department = FactoryBot.build(:department, name: "Physics", shortname: "PHYS")
      html = helper.admin_attr_rows(department, [:name, [:Short, department.shortname]])
      expect(html).to include("Name")
      expect(html).to include("Physics")
      expect(html).to include("Short")
      expect(html).to include("PHYS")
    end

    it "renders an em dash for blank values" do
      department = FactoryBot.build(:department, name: "Physics")
      allow(department).to receive(:shortname).and_return(nil)
      html = helper.admin_attr_rows(department, [:shortname])
      expect(html).to include("—")
    end
  end

  describe "#admin_current_section?" do
    it "returns true when the request path matches a prefix" do
      allow(helper).to receive(:request).and_return(double(path: "/admin/departments/1"))
      expect(helper.admin_current_section?(["/admin/departments"])).to be true
    end

    it "returns false when the request path does not match" do
      allow(helper).to receive(:request).and_return(double(path: "/admin/users"))
      expect(helper.admin_current_section?(["/admin/departments"])).to be false
    end
  end
end
