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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140128225713) do

  create_table "blokade_grants", force: true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blokade_grants", ["permission_id"], name: "index_blokade_grants_on_permission_id", using: :btree
  add_index "blokade_grants", ["role_id"], name: "index_blokade_grants_on_role_id", using: :btree

  create_table "blokade_permissions", force: true do |t|
    t.string   "action"
    t.string   "subject_class"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "backend",             default: false
    t.boolean  "enable_restrictions", default: false
  end

  add_index "blokade_permissions", ["action"], name: "index_blokade_permissions_on_action", using: :btree
  add_index "blokade_permissions", ["backend"], name: "index_blokade_permissions_on_backend", using: :btree
  add_index "blokade_permissions", ["subject_class"], name: "index_blokade_permissions_on_subject_class", using: :btree

  create_table "blokade_powers", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blokade_powers", ["role_id"], name: "index_blokade_powers_on_role_id", using: :btree
  add_index "blokade_powers", ["user_id"], name: "index_blokade_powers_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: true do |t|
    t.string   "name"
    t.integer  "assignable_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leads", ["assignable_id"], name: "index_leads_on_assignable_id", using: :btree
  add_index "leads", ["company_id"], name: "index_leads_on_company_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["company_id"], name: "index_roles_on_company_id", using: :btree
  add_index "roles", ["key"], name: "index_roles_on_key", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree

end
