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

ActiveRecord::Schema.define(version: 20181007111949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "insurance_number"
    t.string "post_code"
    t.inet "registered_from"
    t.geography "current_location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.text "about"
    t.index "((((first_name)::text || ' '::text) || (last_name)::text))", name: "users_full_name_idx"
    t.index "to_tsvector('english'::regconfig, about)", name: "users_about_fulltext_idx", using: :gin
    t.index ["current_location"], name: "index_users_on_current_location", using: :gist
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["insurance_number"], name: "index_users_on_insurance_number", using: :hash
    t.index ["registered_from"], name: "index_users_on_registered_from", using: :brin
  end

end
