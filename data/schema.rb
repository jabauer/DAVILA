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

ActiveRecord::Schema.define(:version => 20100212200737) do

  create_table "assignment_titles", :force => true do |t|
    t.string   "name"
    t.integer  "assignment_type_id"
    t.boolean  "temporary"
    t.boolean  "commissioned"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_titles", ["assignment_type_id"], :name => "assignment_type_id"

  create_table "assignment_types", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer "individual_id"
    t.integer "assignment_title_id"
    t.integer "location_id"
    t.integer "start_year"
    t.boolean "start_certain"
    t.integer "end_year"
    t.boolean "end_certain"
    t.text    "notes"
  end

  add_index "assignments", ["individual_id"], :name => "individual_id"
  add_index "assignments", ["assignment_title_id"], :name => "assignment_title_id"
  add_index "assignments", ["location_id"], :name => "location_id"

  create_table "bibliographies", :force => true do |t|
    t.text     "entry"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citations", :force => true do |t|
    t.string   "title"
    t.integer  "bibliography_id"
    t.string   "pages"
    t.string   "canonic_url"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "citations", ["bibliography_id"], :name => "bibliography_id"

  create_table "continents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empires", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "in_empires", :force => true do |t|
    t.integer  "state_id"
    t.integer  "empire_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_empires", ["state_id"], :name => "state_id"
  add_index "in_empires", ["empire_id"], :name => "empire_id"

  create_table "in_regions", :force => true do |t|
    t.integer  "location_id"
    t.integer  "region_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_regions", ["location_id"], :name => "location_id"
  add_index "in_regions", ["region_id"], :name => "region_id"

  create_table "in_states", :force => true do |t|
    t.integer  "location_id"
    t.integer  "state_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_states", ["location_id"], :name => "location_id"
  add_index "in_states", ["state_id"], :name => "state_id"

  create_table "individuals", :force => true do |t|
    t.string   "name"
    t.string   "sex"
    t.date     "birth_date"
    t.date     "death_date"
    t.integer  "state_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_name"
    t.boolean  "american"
    t.boolean  "birth_day_known"
    t.boolean  "birth_month_known"
    t.boolean  "birth_year_known"
    t.boolean  "death_day_known"
    t.boolean  "death_month_known"
    t.boolean  "death_year_known"
  end

  add_index "individuals", ["state_id"], :name => "state_id"

  create_table "letters", :force => true do |t|
    t.integer  "from_individual_id"
    t.integer  "from_organization_id"
    t.integer  "from_location_id"
    t.integer  "to_individual_id"
    t.integer  "to_organization_id"
    t.integer  "to_location_id"
    t.boolean  "circular"
    t.date     "date_sent"
    t.date     "date_received"
    t.date     "date_docketed"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "sent_day_known"
    t.boolean  "sent_month_known"
    t.boolean  "sent_year_known"
    t.boolean  "received_day_known"
    t.boolean  "received_month_known"
    t.boolean  "received_year_known"
    t.boolean  "docketed_day_known"
    t.boolean  "docketed_month_known"
    t.boolean  "docketed_year_known"
  end

  add_index "letters", ["from_individual_id"], :name => "from_individual_id"
  add_index "letters", ["from_organization_id"], :name => "from_organization_id"
  add_index "letters", ["from_location_id"], :name => "from_location_id"
  add_index "letters", ["to_individual_id"], :name => "to_individual_id"
  add_index "letters", ["to_organization_id"], :name => "to_organization_id"
  add_index "letters", ["to_location_id"], :name => "to_location_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "long"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "individual_id"
    t.integer  "organization_id"
    t.string   "role"
    t.integer  "start_year"
    t.integer  "end_year"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["individual_id"], :name => "individual_id"
  add_index "members", ["organization_id"], :name => "organization_id"

  create_table "occupation_titles", :force => true do |t|
    t.string   "name"
    t.integer  "occupation_type_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occupation_titles", ["occupation_type_id"], :name => "occupation_type_id"

  create_table "occupation_types", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations", :force => true do |t|
    t.integer  "individual_id"
    t.integer  "occupation_title_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occupations", ["individual_id"], :name => "individual_id"
  add_index "occupations", ["occupation_title_id"], :name => "occupation_title_id"

  create_table "org_evolution_types", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "org_evolutions", :force => true do |t|
    t.integer  "org_1_id"
    t.integer  "org_2_id"
    t.integer  "org_evolution_type_id"
    t.date     "date"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "day_known"
    t.boolean  "month_known"
    t.boolean  "year_known"
  end

  add_index "org_evolutions", ["org_1_id"], :name => "org_1_id"
  add_index "org_evolutions", ["org_2_id"], :name => "org_2_id"
  add_index "org_evolutions", ["org_evolution_type_id"], :name => "org_evolution_type_id"

  create_table "organization_types", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.integer  "start_year"
    t.integer  "end_year"
    t.boolean  "magazine_sending"
    t.integer  "organization_type_id"
    t.integer  "location_id"
    t.text     "org_bio"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["organization_type_id"], :name => "organization_type_id"
  add_index "organizations", ["location_id"], :name => "location_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "individual_id_1"
    t.integer  "individual_id_2"
    t.integer  "relationship_type_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["individual_id_1"], :name => "individual_id_1"
  add_index "relationships", ["individual_id_2"], :name => "individual_id_2"
  add_index "relationships", ["relationship_type_id"], :name => "relationship_type_id"

  create_table "residence_types", :force => true do |t|
    t.string   "name"
    t.boolean  "temporary"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "residences", :force => true do |t|
    t.integer  "individual_id"
    t.integer  "location_id"
    t.integer  "residence_type_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.boolean  "birth_place"
    t.boolean  "death_place"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "residences", ["individual_id"], :name => "individual_id"
  add_index "residences", ["location_id"], :name => "location_id"
  add_index "residences", ["residence_type_id"], :name => "residence_type_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "continent_id", :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["continent_id"], :name => "continent_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validations", :force => true do |t|
    t.string   "entity_type"
    t.integer  "entity_key"
    t.boolean  "supports"
    t.integer  "user_id"
    t.integer  "citation_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "validations", ["user_id"], :name => "user_id"
  add_index "validations", ["citation_id"], :name => "citation_id"

  add_foreign_key "assignment_titles", ["assignment_type_id"], "assignment_types", ["id"], :name => "assignment_titles_ibfk_1"

  add_foreign_key "assignments", ["individual_id"], "individuals", ["id"], :name => "assignments_ibfk_1"
  add_foreign_key "assignments", ["assignment_title_id"], "assignment_titles", ["id"], :name => "assignments_ibfk_2"
  add_foreign_key "assignments", ["location_id"], "locations", ["id"], :name => "assignments_ibfk_3"

  add_foreign_key "citations", ["bibliography_id"], "bibliographies", ["id"], :name => "citations_ibfk_1"

  add_foreign_key "in_empires", ["state_id"], "states", ["id"], :name => "in_empires_ibfk_1"
  add_foreign_key "in_empires", ["empire_id"], "empires", ["id"], :name => "in_empires_ibfk_2"

  add_foreign_key "in_regions", ["location_id"], "locations", ["id"], :name => "in_regions_ibfk_1"
  add_foreign_key "in_regions", ["region_id"], "regions", ["id"], :name => "in_regions_ibfk_2"

  add_foreign_key "in_states", ["location_id"], "locations", ["id"], :name => "in_states_ibfk_1"
  add_foreign_key "in_states", ["state_id"], "states", ["id"], :name => "in_states_ibfk_2"

  add_foreign_key "individuals", ["state_id"], "states", ["id"], :name => "individuals_ibfk_1"

  add_foreign_key "letters", ["from_individual_id"], "individuals", ["id"], :name => "letters_ibfk_1"
  add_foreign_key "letters", ["from_organization_id"], "organizations", ["id"], :name => "letters_ibfk_2"
  add_foreign_key "letters", ["from_location_id"], "locations", ["id"], :name => "letters_ibfk_3"
  add_foreign_key "letters", ["to_individual_id"], "individuals", ["id"], :name => "letters_ibfk_4"
  add_foreign_key "letters", ["to_organization_id"], "organizations", ["id"], :name => "letters_ibfk_5"
  add_foreign_key "letters", ["to_location_id"], "locations", ["id"], :name => "letters_ibfk_6"

  add_foreign_key "members", ["individual_id"], "individuals", ["id"], :name => "members_ibfk_1"
  add_foreign_key "members", ["organization_id"], "organizations", ["id"], :name => "members_ibfk_2"

  add_foreign_key "occupation_titles", ["occupation_type_id"], "occupation_types", ["id"], :name => "occupation_titles_ibfk_1"

  add_foreign_key "occupations", ["individual_id"], "individuals", ["id"], :name => "occupations_ibfk_1"
  add_foreign_key "occupations", ["occupation_title_id"], "occupation_titles", ["id"], :name => "occupations_ibfk_2"

  add_foreign_key "org_evolutions", ["org_1_id"], "organizations", ["id"], :name => "org_evolutions_ibfk_1"
  add_foreign_key "org_evolutions", ["org_2_id"], "organizations", ["id"], :name => "org_evolutions_ibfk_2"
  add_foreign_key "org_evolutions", ["org_evolution_type_id"], "org_evolution_types", ["id"], :name => "org_evolutions_ibfk_3"

  add_foreign_key "organizations", ["organization_type_id"], "organization_types", ["id"], :name => "organizations_ibfk_1"
  add_foreign_key "organizations", ["location_id"], "locations", ["id"], :name => "organizations_ibfk_2"

  add_foreign_key "relationships", ["individual_id_1"], "individuals", ["id"], :name => "relationships_ibfk_1"
  add_foreign_key "relationships", ["individual_id_2"], "individuals", ["id"], :name => "relationships_ibfk_2"
  add_foreign_key "relationships", ["relationship_type_id"], "relationship_types", ["id"], :name => "relationships_ibfk_3"

  add_foreign_key "residences", ["individual_id"], "individuals", ["id"], :name => "residences_ibfk_1"
  add_foreign_key "residences", ["location_id"], "locations", ["id"], :name => "residences_ibfk_2"
  add_foreign_key "residences", ["residence_type_id"], "residence_types", ["id"], :name => "residences_ibfk_3"

  add_foreign_key "states", ["continent_id"], "continents", ["id"], :name => "states_ibfk_1"

  add_foreign_key "validations", ["user_id"], "users", ["id"], :name => "validations_ibfk_1"
  add_foreign_key "validations", ["citation_id"], "citations", ["id"], :name => "validations_ibfk_2"

end
