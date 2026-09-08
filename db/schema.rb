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

ActiveRecord::Schema[8.1].define(version: 2026_09_04_151659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "uuid-ossp"

  create_table "backup_noas", force: :cascade do |t|
    t.integer "attempts"
    t.string "collection_ref"
    t.datetime "created_at", null: false
    t.text "data"
    t.string "filename"
    t.string "folder"
    t.datetime "updated_at", null: false
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.datetime "invitation_accepted_at"
    t.datetime "invitation_created_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "user", null: false
    t.string "session_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_employees_on_confirmation_token", unique: true
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["invitation_token"], name: "index_employees_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_employees_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_employees_on_invited_by"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "tribunal_cases", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "another_test_column"
    t.string "case_reference"
    t.string "case_status"
    t.string "case_type"
    t.string "case_type_other_value"
    t.string "challenged_decision"
    t.string "challenged_decision_status"
    t.text "closure_additional_info"
    t.string "closure_case_type"
    t.string "closure_hmrc_officer"
    t.string "closure_hmrc_reference"
    t.string "closure_years_under_enquiry"
    t.datetime "created_at", null: false
    t.boolean "disabled_access"
    t.string "dispute_type"
    t.string "dispute_type_other_value"
    t.string "disputed_tax_paid"
    t.boolean "eu_exit"
    t.uuid "files_collection_ref", default: -> { "uuid_generate_v4()" }
    t.text "grounds_for_appeal"
    t.text "hardship_reason"
    t.string "hardship_review_requested"
    t.string "hardship_review_status"
    t.string "has_representative"
    t.boolean "having_problems_uploading", default: false
    t.text "having_problems_uploading_explanation"
    t.boolean "hearing_loop"
    t.string "in_time"
    t.string "intent"
    t.string "language"
    t.boolean "language_interpreter"
    t.string "language_interpreter_details"
    t.text "lateness_reason"
    t.string "letter_upload_type"
    t.string "navigation_stack", default: [], array: true
    t.string "need_support"
    t.boolean "other_support"
    t.string "other_support_details"
    t.text "outcome"
    t.string "pdf_generation_status"
    t.string "penalty_amount"
    t.string "penalty_level"
    t.text "representative_contact_address"
    t.string "representative_contact_city"
    t.string "representative_contact_country"
    t.string "representative_contact_email"
    t.string "representative_contact_phone"
    t.string "representative_contact_postcode"
    t.boolean "representative_feedback_consent", default: false
    t.string "representative_individual_first_name"
    t.string "representative_individual_last_name"
    t.string "representative_organisation_fao"
    t.string "representative_organisation_name"
    t.string "representative_organisation_registration_number"
    t.string "representative_professional_status"
    t.string "representative_type"
    t.string "send_representative_copy"
    t.string "send_taxpayer_copy"
    t.boolean "sign_language_interpreter"
    t.string "sign_language_interpreter_details"
    t.datetime "submitted_at"
    t.string "tax_amount"
    t.text "taxpayer_contact_address"
    t.string "taxpayer_contact_city"
    t.string "taxpayer_contact_country"
    t.string "taxpayer_contact_email"
    t.string "taxpayer_contact_phone"
    t.string "taxpayer_contact_postcode"
    t.boolean "taxpayer_feedback_consent", default: false
    t.string "taxpayer_individual_first_name"
    t.string "taxpayer_individual_last_name"
    t.string "taxpayer_organisation_fao"
    t.string "taxpayer_organisation_name"
    t.string "taxpayer_organisation_registration_number"
    t.string "taxpayer_type"
    t.datetime "updated_at", null: false
    t.string "user_case_reference"
    t.uuid "user_id"
    t.string "user_type"
    t.index ["case_reference"], name: "index_tribunal_cases_on_case_reference", unique: true
    t.index ["user_id"], name: "index_tribunal_cases_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "session_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "tribunal_cases", "users"
end
