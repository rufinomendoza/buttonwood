# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120905040229) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "holdings", :force => true do |t|
    t.integer  "portfolio_id"
    t.integer  "security_id"
    t.float    "shares_held"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "holdings", ["portfolio_id"], :name => "index_holdings_on_portfolio_id"
  add_index "holdings", ["security_id"], :name => "index_holdings_on_security_id"

  create_table "portfolios", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "ips"
    t.float    "cash"
  end

  add_index "portfolios", ["user_id"], :name => "index_portfolios_on_user_id"

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sectors", ["user_id"], :name => "index_sectors_on_user_id"

  create_table "securities", :force => true do |t|
    t.integer  "user_id"
    t.string   "symbol"
    t.float    "our_price_target"
    t.float    "our_current_year_eps"
    t.float    "our_next_year_eps"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "sector_id"
  end

  add_index "securities", ["symbol"], :name => "index_securities_on_symbol"
  add_index "securities", ["user_id"], :name => "index_securities_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
