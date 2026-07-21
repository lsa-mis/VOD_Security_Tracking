require "rails_helper"

RSpec.describe "Admin access", type: :request do
  let(:admin_group) { "lsa-vod-admins" }
  let(:user) { FactoryBot.create(:user) }

  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
    FactoryBot.create(:access_lookup, ldap_group: admin_group, vod_table: :admin_interface, vod_action: :all)
  end

  def sign_in_admin
    sign_in user
    set_session(:user_memberships, [admin_group])
  end

  def sign_in_non_admin
    sign_in user
    set_session(:user_memberships, ["some-other-group"])
  end

  describe "GET /admin" do
    it "redirects guests to sign in" do
      get admin_root_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "denies non-admin users" do
      sign_in_non_admin
      get admin_root_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end

    it "allows admin users" do
      sign_in_admin
      get admin_root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Dashboard")
    end
  end

  describe "CRUD resources" do
    before { sign_in_admin }

    it "lists and creates departments" do
      get admin_departments_path
      expect(response).to have_http_status(:ok)

      expect {
        post admin_departments_path, params: { department: { name: "English", shortname: "ENGL", active_dir_group: "lsa-engl" } }
      }.to change(Department, :count).by(1)
      expect(response).to redirect_to(admin_department_path(Department.last))
    end

    it "exports departments as CSV" do
      FactoryBot.create(:department)
      get admin_departments_path(format: :csv)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
    end

    it "creates and updates notifications" do
      get new_admin_notification_path
      expect(response).to have_http_status(:ok)

      expect {
        post admin_notifications_path, params: {
          notification: {
            note: "Maintenance window",
            notetype: "notice",
            opendate: 2.days.from_now,
            closedate: 4.days.from_now
          }
        }
      }.to change(Notification, :count).by(1)

      notification = Notification.last
      patch admin_notification_path(notification), params: {
        notification: { note: "Updated maintenance window" }
      }
      expect(notification.reload.note).to eq("Updated maintenance window")
    end

    it "creates storage locations and data classification levels" do
      expect {
        post admin_storage_locations_path, params: {
          storage_location: { name: "Local Disk", description: "On device", device_is_required: true }
        }
      }.to change(StorageLocation, :count).by(1)

      expect {
        post admin_data_classification_levels_path, params: {
          data_classification_level: { name: "Restricted", description: "Highest" }
        }
      }.to change(DataClassificationLevel, :count).by(1)
    end

    it "batch destroys access lookups" do
      a = FactoryBot.create(:access_lookup, ldap_group: "g1", vod_table: :devices, vod_action: :show)
      b = FactoryBot.create(:access_lookup, ldap_group: "g2", vod_table: :devices, vod_action: :show)
      delete batch_destroy_admin_access_lookups_path, params: { ids: [a.id, b.id] }
      expect(AccessLookup.where(id: [a.id, b.id])).to be_empty
    end
  end

  describe "read-only main tables" do
    before { sign_in_admin }

    it "lists active IT security incidents and shows a record" do
      incident = FactoryBot.create(:it_security_incident)
      get admin_it_security_incidents_path
      expect(response).to have_http_status(:ok)

      get admin_it_security_incident_path(incident)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Comments")
    end

    it "lists DSA exceptions" do
      FactoryBot.create(:dpa_exception)
      get admin_dpa_exceptions_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("DSA Exceptions")
    end

    it "lists legacy OS records and sensitive data systems" do
      FactoryBot.create(:legacy_os_record)
      FactoryBot.create(:sensitive_data_system)

      get admin_legacy_os_records_path
      expect(response).to have_http_status(:ok)

      get admin_sensitive_data_systems_path
      expect(response).to have_http_status(:ok)
    end

    it "lists devices and supports incomplete scope" do
      FactoryBot.create(:device)
      get admin_devices_path
      expect(response).to have_http_status(:ok)

      get admin_devices_path(scope: "incomplete")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "comments" do
    before { sign_in_admin }

    it "creates a comment on a department" do
      department = FactoryBot.create(:department)
      expect {
        post admin_comments_path, params: {
          comment: { body: "Note", resource_type: "Department", resource_id: department.id, namespace: "admin" }
        }
      }.to change(Comment, :count).by(1)
    end

    it "does not create a comment without a body" do
      department = FactoryBot.create(:department)
      expect {
        post admin_comments_path, params: {
          comment: { body: "", resource_type: "Department", resource_id: department.id, namespace: "admin" }
        }
      }.not_to change(Comment, :count)
    end
  end
end
