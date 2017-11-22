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

ActiveRecord::Schema.define(version: 20171122135324) do

  create_table "actors", force: :cascade do |t|
    t.string "email"
    t.string "fullname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "superadmin"
  end

  create_table "clusters", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "endpoint"
    t.string "cert"
    t.string "key"
    t.string "ca"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clusters_projects", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "cluster_id", null: false
  end

  create_table "ngsi_subscriptions", force: :cascade do |t|
    t.string "name"
    t.integer "throttling"
    t.integer "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscription_id"
    t.string "description"
    t.string "subject"
    t.string "notification"
    t.string "expires"
    t.string "status"
    t.integer "project_id"
    t.index ["project_id"], name: "index_ngsi_subscriptions_on_project_id"
    t.index ["service_id"], name: "index_ngsi_subscriptions_on_service_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "role_level_id"
    t.integer "project_id"
    t.integer "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_roles_on_actor_id"
    t.index ["project_id"], name: "index_roles_on_project_id"
    t.index ["role_level_id"], name: "index_roles_on_role_level_id"
  end

  create_table "service_types", force: :cascade do |t|
    t.string "service_protocol_type"
    t.string "ngsi_version"
    t.text "configuration_template"
    t.text "deploy_template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "version"
  end

  create_table "services", force: :cascade do |t|
    t.text "configuration"
    t.string "status"
    t.boolean "managed"
    t.text "endpoint"
    t.float "latitude"
    t.float "longitude"
    t.integer "project_id"
    t.integer "service_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "docker_service_id"
    t.integer "cluster_id"
    t.string "name"
    t.index ["cluster_id"], name: "index_services_on_cluster_id"
    t.index ["project_id"], name: "index_services_on_project_id"
    t.index ["service_type_id"], name: "index_services_on_service_type_id"
  end

end
