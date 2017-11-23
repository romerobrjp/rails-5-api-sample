# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171120161201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campuses", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.bigint "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_campuses_on_university_id"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string "name"
    t.string "formation_area"
    t.bigint "university_id"
    t.bigint "campus_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.string "gender"
    t.index ["campus_id"], name: "index_professors_on_campus_id"
    t.index ["university_id"], name: "index_professors_on_university_id"
  end

  create_table "professors_disciplines", force: :cascade do |t|
    t.bigint "professor_id"
    t.bigint "discipline_id"
    t.index ["discipline_id"], name: "index_professors_disciplines_on_discipline_id"
    t.index ["professor_id"], name: "index_professors_disciplines_on_professor_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "acronym"
    t.string "name"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
