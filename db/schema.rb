# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110215100240) do

  create_table "appeals", :force => true do |t|
    t.integer  "question_index"
    t.string   "answer"
    t.string   "goal"
    t.string   "argument"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calc_systems", :force => true do |t|
    t.string "short_name"
    t.string "name"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities_tournaments", :id => false, :force => true do |t|
    t.integer "city_id"
    t.integer "tournament_id"
  end

  create_table "disputeds", :force => true do |t|
    t.integer  "question_index"
    t.string   "answer"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.date     "date"
    t.string   "moderator_name"
    t.string   "moderator_email"
    t.integer  "city_id"
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.integer  "num_questions"
    t.date     "begin"
    t.date     "end"
    t.date     "submit_disp_until"
    t.date     "submit_appeal_until"
    t.date     "submit_results_until"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_tours"
    t.boolean  "publish_disp",         :default => false
    t.boolean  "publish_appeal",       :default => false
    t.boolean  "publish_results",      :default => false
  end

  create_table "resultitems", :force => true do |t|
    t.integer  "result_id"
    t.integer  "score"
    t.integer  "question_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "score"
    t.integer  "team_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating_id"
    t.integer  "city_id"
  end

  add_index "teams", ["rating_id"], :name => "index_teams_on_rating_id"

  create_table "tournament_results", :force => true do |t|
    t.float   "place",         :default => 0.0
    t.integer "tournament_id"
    t.integer "team_id"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.boolean  "needTeams"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "appeal_for_dismiss"
    t.integer  "calc_system_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 100
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "status"
    t.string   "reset_code"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
