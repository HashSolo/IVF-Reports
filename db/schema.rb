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

ActiveRecord::Schema.define(:version => 20120407051645) do

  create_table "clinics", :force => true do |t|
    t.string   "clinic_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "region"
    t.string   "practice_director"
    t.string   "medical_director"
    t.string   "laboratory_director"
    t.string   "phone"
    t.string   "website"
    t.string   "email"
    t.string   "info"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_clinic_id"
    t.string   "permalink"
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "datapoints", :force => true do |t|
    t.integer  "clinic_id"
    t.string   "age_group"
    t.string   "year"
    t.string   "diagnosis"
    t.string   "cycle_type"
    t.integer  "cycles"
    t.float    "implantation_rate"
    t.float    "avg_num_embs_transferred"
    t.float    "pregs_per_cycle"
    t.float    "births_per_cycle"
    t.float    "births_per_retrieval"
    t.float    "births_per_transfer"
    t.float    "set_transfer_rate"
    t.float    "cancellation_rate"
    t.float    "twin_rate"
    t.float    "trip_rate"
    t.float    "procedure_ivf_rate"
    t.float    "procedure_gift_rate"
    t.float    "procedure_zift_rate"
    t.float    "procedure_icsi_rate"
    t.float    "procedure_unstimulated_rate"
    t.float    "procedure_pgd_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "datapoints", ["age_group"], :name => "index_datapoints_on_age_group"
  add_index "datapoints", ["clinic_id"], :name => "index_datapoints_on_clinic_id"
  add_index "datapoints", ["diagnosis"], :name => "index_datapoints_on_diagnosis"
  add_index "datapoints", ["year"], :name => "index_datapoints_on_year"

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.integer  "request_id"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "clinic_id"
    t.boolean  "visible",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "purchased_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "clinic_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "clinic_id"
    t.string   "year"
    t.string   "age_group"
    t.string   "diagnosis"
    t.string   "cycle_type"
    t.float    "ivf_reports_score"
    t.float    "quality_score"
    t.float    "safety_score"
    t.float    "sart_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["age_group"], :name => "index_scores_on_age_group"
  add_index "scores", ["clinic_id"], :name => "index_scores_on_clinic_id"
  add_index "scores", ["diagnosis"], :name => "index_scores_on_diagnosis"
  add_index "scores", ["year"], :name => "index_scores_on_year"

  create_table "states", :force => true do |t|
    t.string   "abbrev"
    t.string   "name"
    t.integer  "population"
    t.string   "capital"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'weight' for column 'weight'

end
