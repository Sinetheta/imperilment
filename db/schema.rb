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

ActiveRecord::Schema.define(version: 2015_03_07_173552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer "game_id"
    t.integer "category_id"
    t.text "correct_question"
    t.text "answer"
    t.integer "amount"
    t.date "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_id"], name: "index_answers_on_category_id"
    t.index ["game_id"], name: "index_answers_on_game_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_results", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.integer "total"
    t.integer "position"
    t.index ["game_id"], name: "index_game_results_on_game_id"
    t.index ["position"], name: "index_game_results_on_position"
    t.index ["user_id"], name: "index_game_results_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.date "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "locked", default: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "answer_id"
    t.string "response"
    t.boolean "correct"
    t.integer "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["answer_id"], name: "index_questions_on_answer_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "web_hooks", force: :cascade do |t|
    t.string "url"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
