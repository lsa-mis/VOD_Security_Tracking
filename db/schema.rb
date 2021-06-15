# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_09_211530) do

  create_table "access_lookups", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ldap_group"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "table", default: 0, null: false
    t.integer "action", default: 0, null: false
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "data_classification_levels", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "description_link"
    t.bigint "data_classification_level_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_classification_level_id"], name: "index_data_types_on_data_classification_level_id"
  end

  create_table "devices", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "serial"
    t.string "hostname"
    t.string "mac"
    t.string "building"
    t.string "room"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "owner"
    t.string "department"
    t.string "manufacturer"
    t.string "model"
  end

  create_table "dpa_exceptions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "review_date_exception_first_approval_date"
    t.text "third_party_product_service", null: false
    t.string "used_by"
    t.string "point_of_contact"
    t.text "review_findings"
    t.text "review_summary"
    t.text "lsa_security_recommendation"
    t.text "lsa_security_determination"
    t.string "lsa_security_approval"
    t.string "lsa_technology_services_approval"
    t.datetime "exception_approval_date_exception_renewal_date_due"
    t.string "notes"
    t.string "sla_agreement"
    t.bigint "data_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.boolean "incomplete", default: false
    t.datetime "review_date_exception_review_date"
    t.index ["data_type_id"], name: "index_dpa_exceptions_on_data_type_id"
  end

  create_table "it_security_incident_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "it_security_incidents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "date"
    t.text "people_involved", null: false
    t.text "equipment_involved", null: false
    t.text "remediation_steps", null: false
    t.integer "estimated_finacial_cost"
    t.text "notes"
    t.bigint "it_security_incident_status_id"
    t.bigint "data_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.boolean "incomplete", default: false
    t.index ["data_type_id"], name: "index_it_security_incidents_on_data_type_id"
    t.index ["it_security_incident_status_id"], name: "index_it_security_incidents_on_it_security_incident_status_id"
  end

  create_table "legacy_os_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "owner_username", null: false
    t.string "owner_full_name", null: false
    t.string "dept"
    t.string "phone"
    t.string "additional_dept_contact"
    t.string "additional_dept_contact_phone"
    t.string "support_poc"
    t.string "legacy_os"
    t.string "unique_app"
    t.string "unique_hardware"
    t.datetime "unique_date"
    t.string "remediation"
    t.datetime "exception_approval_date"
    t.datetime "review_date"
    t.string "review_contact"
    t.string "justification"
    t.string "local_it_support_group"
    t.text "notes"
    t.bigint "data_type_id"
    t.bigint "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.boolean "incomplete", default: false
    t.index ["data_type_id"], name: "index_legacy_os_records_on_data_type_id"
    t.index ["device_id"], name: "index_legacy_os_records_on_device_id"
  end

  create_table "sensitive_data_system_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sensitive_data_systems", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "owner_username", null: false
    t.string "owner_full_name", null: false
    t.string "dept"
    t.string "phone"
    t.string "additional_dept_contact"
    t.string "additional_dept_contact_phone"
    t.string "support_poc"
    t.text "expected_duration_of_data_retention"
    t.string "agreements_related_to_data_types"
    t.datetime "review_date"
    t.string "review_contact"
    t.string "notes"
    t.bigint "storage_location_id", null: false
    t.bigint "data_type_id"
    t.bigint "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.boolean "incomplete", default: false
    t.bigint "sensitive_data_system_type_id", null: false
    t.index ["data_type_id"], name: "index_sensitive_data_systems_on_data_type_id"
    t.index ["device_id"], name: "index_sensitive_data_systems_on_device_id"
    t.index ["sensitive_data_system_type_id"], name: "index_sensitive_data_systems_on_sensitive_data_system_type_id"
    t.index ["storage_location_id"], name: "index_sensitive_data_systems_on_storage_location_id"
  end

  create_table "storage_locations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "description_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tdx_tickets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "records_to_tdx_type", null: false
    t.bigint "records_to_tdx_id", null: false
    t.string "ticket_link"
    t.index ["records_to_tdx_type", "records_to_tdx_id"], name: "index_tdx_tickets_on_records_to_tdx"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "username", default: "", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "data_types", "data_classification_levels"
  add_foreign_key "dpa_exceptions", "data_types"
  add_foreign_key "it_security_incidents", "data_types"
  add_foreign_key "it_security_incidents", "it_security_incident_statuses"
  add_foreign_key "legacy_os_records", "data_types"
  add_foreign_key "legacy_os_records", "devices"
  add_foreign_key "sensitive_data_systems", "data_types"
  add_foreign_key "sensitive_data_systems", "devices"
  add_foreign_key "sensitive_data_systems", "sensitive_data_system_types"
  add_foreign_key "sensitive_data_systems", "storage_locations"
end
