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

ActiveRecord::Schema[8.1].define(version: 2026_07_16_150000) do
  create_table "access_lookups", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ldap_group"
    t.datetime "updated_at", null: false
    t.integer "vod_action", default: 0, null: false
    t.integer "vod_table", default: 0, null: false
  end

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "body", size: :long
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "action"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "auditable_id"
    t.string "auditable_type"
    t.text "audited_changes"
    t.string "comment"
    t.datetime "created_at", precision: nil
    t.string "remote_address"
    t.string "request_uuid"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.integer "version", default: 0
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace", default: "admin"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_comments_on_resource_type_and_resource_id"
  end

  create_table "data_classification_levels", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "data_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "data_classification_level_id", null: false
    t.string "description"
    t.string "description_link"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["data_classification_level_id"], name: "index_data_types_on_data_classification_level_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "active_dir_group"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "shortname"
    t.datetime "updated_at", null: false
  end

  create_table "devices", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "building"
    t.datetime "created_at", null: false
    t.string "department"
    t.string "hostname"
    t.string "mac"
    t.string "manufacturer"
    t.string "model"
    t.string "owner"
    t.string "room"
    t.string "serial"
    t.datetime "updated_at", null: false
  end

  create_table "dpa_exception_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "dpa_exceptions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "data_type_id"
    t.datetime "deleted_at", precision: nil
    t.bigint "department_id", null: false
    t.bigint "dpa_exception_status_id", null: false
    t.datetime "exception_approval_date_exception_renewal_date_due", precision: nil
    t.boolean "incomplete", default: false
    t.string "lsa_security_approval"
    t.string "lsa_technology_services_approval"
    t.string "point_of_contact"
    t.datetime "review_date_exception_first_approval_date", precision: nil
    t.datetime "review_date_exception_review_date", precision: nil
    t.string "sla_agreement"
    t.string "third_party_product_service", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_dpa_exceptions_on_data_type_id"
    t.index ["department_id"], name: "index_dpa_exceptions_on_department_id"
    t.index ["dpa_exception_status_id"], name: "index_dpa_exceptions_on_dpa_exception_status_id"
  end

  create_table "infotexts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location", null: false
    t.datetime "updated_at", null: false
  end

  create_table "it_security_incident_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "it_security_incidents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "data_type_id", null: false
    t.datetime "date", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "estimated_financial_cost"
    t.boolean "incomplete", default: false
    t.bigint "it_security_incident_status_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_it_security_incidents_on_data_type_id"
    t.index ["it_security_incident_status_id"], name: "index_it_security_incidents_on_it_security_incident_status_id"
  end

  create_table "legacy_os_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "additional_dept_contact"
    t.string "additional_dept_contact_phone"
    t.datetime "created_at", null: false
    t.bigint "data_type_id"
    t.datetime "deleted_at", precision: nil
    t.bigint "department_id", null: false
    t.bigint "device_id"
    t.datetime "exception_approval_date", precision: nil
    t.boolean "incomplete", default: false
    t.string "legacy_os"
    t.string "local_it_support_group"
    t.string "owner_full_name", null: false
    t.string "owner_username", null: false
    t.string "phone"
    t.string "review_contact"
    t.datetime "review_date", precision: nil
    t.string "support_poc"
    t.string "unique_app"
    t.datetime "unique_date", precision: nil
    t.string "unique_hardware"
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_legacy_os_records_on_data_type_id"
    t.index ["department_id"], name: "index_legacy_os_records_on_department_id"
    t.index ["device_id"], name: "index_legacy_os_records_on_device_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "closedate", precision: nil
    t.datetime "created_at", null: false
    t.string "note"
    t.string "notetype"
    t.datetime "opendate", precision: nil
    t.datetime "updated_at", null: false
  end

  create_table "sensitive_data_systems", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "additional_dept_contact"
    t.string "additional_dept_contact_phone"
    t.string "agreements_related_to_data_types"
    t.datetime "created_at", null: false
    t.bigint "data_type_id"
    t.datetime "deleted_at", precision: nil
    t.bigint "department_id", null: false
    t.bigint "device_id"
    t.string "expected_duration_of_data_retention"
    t.boolean "incomplete", default: false
    t.string "name", null: false
    t.string "owner_full_name", null: false
    t.string "owner_username", null: false
    t.string "phone"
    t.string "review_contact"
    t.datetime "review_date", precision: nil
    t.bigint "storage_location_id"
    t.string "support_poc"
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_sensitive_data_systems_on_data_type_id"
    t.index ["department_id"], name: "index_sensitive_data_systems_on_department_id"
    t.index ["device_id"], name: "index_sensitive_data_systems_on_device_id"
    t.index ["storage_location_id"], name: "index_sensitive_data_systems_on_storage_location_id"
  end

  create_table "solid_cable_messages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.binary "channel", limit: 1024, null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", size: :long, null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", limit: 1024, null: false
    t.bigint "key_hash", null: false
    t.binary "value", size: :long, null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "storage_locations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "description_link"
    t.boolean "device_is_required", default: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "tdx_tickets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "records_to_tdx_id", null: false
    t.string "records_to_tdx_type", null: false
    t.string "ticket_link"
    t.datetime "updated_at", null: false
    t.index ["records_to_tdx_type", "records_to_tdx_id"], name: "index_tdx_tickets_on_records_to_tdx"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: ""
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "data_types", "data_classification_levels"
  add_foreign_key "dpa_exceptions", "data_types"
  add_foreign_key "dpa_exceptions", "departments"
  add_foreign_key "it_security_incidents", "data_types"
  add_foreign_key "it_security_incidents", "it_security_incident_statuses"
  add_foreign_key "legacy_os_records", "data_types"
  add_foreign_key "legacy_os_records", "departments"
  add_foreign_key "legacy_os_records", "devices"
  add_foreign_key "sensitive_data_systems", "data_types"
  add_foreign_key "sensitive_data_systems", "departments"
  add_foreign_key "sensitive_data_systems", "devices"
  add_foreign_key "sensitive_data_systems", "storage_locations"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
