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

ActiveRecord::Schema[7.0].define(version: 2024_09_06_120216) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "report"
    t.integer "late"
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["student_id"], name: "index_activities_on_student_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.integer "number"
    t.string "unit"
    t.string "neighborhood"
    t.string "state"
    t.string "country"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.boolean "presence", default: true
    t.date "attendance_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_attendances_on_student_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name"
    t.string "time"
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_classrooms_on_teacher_id"
  end

  create_table "current_plans", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.boolean "has_discount", default: false, null: false
    t.integer "discount"
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total", precision: 10, scale: 2
    t.index ["plan_id"], name: "index_current_plans_on_plan_id"
    t.index ["student_id"], name: "index_current_plans_on_student_id"
  end

  create_table "financial_responsibles", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "cpf"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_fees", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.decimal "value", precision: 10, scale: 2
    t.integer "status"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_discount", default: false, null: false
    t.decimal "discount_rate", precision: 5, scale: 2
    t.index ["student_id"], name: "index_monthly_fees_on_student_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responsibles", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "financial_responsible_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["financial_responsible_id"], name: "index_responsibles_on_financial_responsible_id"
    t.index ["student_id"], name: "index_responsibles_on_student_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.text "written_report"
    t.integer "status"
    t.date "date"
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_resumes_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.string "phone"
    t.string "cel_phone"
    t.string "email"
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.bigint "user_id", default: 0, null: false
    t.string "cel_phone"
    t.string "phone"
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "students"
  add_foreign_key "attendances", "students"
  add_foreign_key "classrooms", "teachers"
  add_foreign_key "current_plans", "plans"
  add_foreign_key "current_plans", "students"
  add_foreign_key "monthly_fees", "students"
  add_foreign_key "responsibles", "financial_responsibles"
  add_foreign_key "responsibles", "students"
  add_foreign_key "resumes", "students"
  add_foreign_key "students", "classrooms"
  add_foreign_key "teachers", "users"
end
