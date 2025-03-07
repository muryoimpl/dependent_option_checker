# frozen_string_literal: true

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

ActiveRecord::Schema[7.2].define(version: 20_250_307_141_946) do
  create_table 'accounts', force: :cascade do |t|
    t.string 'email', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'members', force: :cascade do |t|
    t.integer 'organization_id'
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['organization_id'], name: 'index_members_on_organization_id'
  end

  create_table 'organizations', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'owner_account_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['owner_account_id'], name: 'index_organizations_on_owner_account_id'
  end

  add_foreign_key 'organizations', 'accounts', column: 'owner_account_id'
end
