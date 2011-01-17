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

ActiveRecord::Schema.define(:version => 20100724104105) do

  create_table "appeals", :force => true do |t|
    t.integer  "question_index"
    t.string   "answer"
    t.string   "goal"
    t.string   "argument"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.boolean  "needTeams"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "appeal_for_dismiss"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
