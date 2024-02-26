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

ActiveRecord::Schema.define(version: 2024_02_26_013600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.bigint "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "credit_hours"
    t.index ["author_id"], name: "index_courses_on_author_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "talent_id", null: false
    t.bigint "course_id", null: false
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["talent_id"], name: "index_enrollments_on_talent_id"
  end

  create_table "learning_path_courses", force: :cascade do |t|
    t.bigint "learning_path_id", null: false
    t.bigint "course_id", null: false
    t.integer "sequence", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_learning_path_courses_on_course_id"
    t.index ["learning_path_id", "sequence"], name: "index_learning_path_courses_on_learning_path_id_and_sequence", unique: true
    t.index ["learning_path_id"], name: "index_learning_path_courses_on_learning_path_id"
  end

  create_table "learning_path_enrollments", force: :cascade do |t|
    t.bigint "talent_id", null: false
    t.bigint "learning_path_id", null: false
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["learning_path_id"], name: "index_learning_path_enrollments_on_learning_path_id"
    t.index ["talent_id"], name: "index_learning_path_enrollments_on_talent_id"
  end

  create_table "learning_paths", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.bigint "author_id"
    t.index ["author_id"], name: "index_talents_on_author_id"
  end

  add_foreign_key "courses", "authors"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "talents"
  add_foreign_key "learning_path_courses", "courses"
  add_foreign_key "learning_path_courses", "learning_paths"
  add_foreign_key "learning_path_enrollments", "learning_paths"
  add_foreign_key "learning_path_enrollments", "talents"
  add_foreign_key "talents", "authors"
end
