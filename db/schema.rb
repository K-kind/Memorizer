# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_24_145339) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "calendars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.date "calendar_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["calendar_date", "user_id"], name: "index_calendars_on_calendar_date_and_user_id", unique: true
    t.index ["calendar_date"], name: "index_calendars_on_calendar_date"
    t.index ["user_id"], name: "index_calendars_on_user_id"
  end

  create_table "consulted_words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "word_definition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_consulted_words_on_user_id"
  end

  create_table "contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "comment"
    t.boolean "from_admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "cycles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "times"
    t.integer "cycle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_cycles_on_user_id"
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "learned_content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["learned_content_id"], name: "index_favorites_on_learned_content_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "later_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "word"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_later_lists_on_user_id"
  end

  create_table "learn_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_learn_templates_on_user_id"
  end

  create_table "learned_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "word_category_id", null: false
    t.bigint "word_definition_id", null: false
    t.boolean "is_public", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "imported", default: false
    t.boolean "completed", default: false
    t.bigint "calendar_id", null: false
    t.integer "imported_from"
    t.boolean "is_test", default: false
    t.date "review_date"
    t.index ["calendar_id"], name: "index_learned_contents_on_calendar_id"
    t.index ["created_at", "imported_from", "is_public"], name: "index_learned_contents_imported_latest"
    t.index ["user_id", "imported_from"], name: "index_learned_contents_on_user_id_and_imported_from"
    t.index ["user_id"], name: "index_learned_contents_on_user_id"
    t.index ["word_category_id"], name: "index_learned_contents_on_word_category_id"
    t.index ["word_definition_id"], name: "index_learned_contents_on_word_definition_id"
  end

  create_table "levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "threshold", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "level"
    t.index ["level"], name: "index_levels_on_level"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "to_admin", default: false
    t.boolean "checked", default: false
    t.integer "action", default: 1
    t.integer "contact_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "learned_content_id", null: false
    t.text "question"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["learned_content_id"], name: "index_questions_on_learned_content_id"
  end

  create_table "related_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "learned_content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "word"
    t.string "image"
    t.string "thumbnail_url"
    t.index ["learned_content_id"], name: "index_related_images_on_learned_content_id"
  end

  create_table "related_words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "learned_content_id", null: false
    t.bigint "word_definition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["learned_content_id"], name: "index_related_words_on_learned_content_id"
    t.index ["word_definition_id"], name: "index_related_words_on_word_definition_id"
  end

  create_table "review_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "learned_content_id", null: false
    t.boolean "again", default: false
    t.integer "similarity_ratio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "calendar_id", null: false
    t.index ["calendar_id"], name: "index_review_histories_on_calendar_id"
    t.index ["learned_content_id"], name: "index_review_histories_on_learned_content_id"
  end

  create_table "user_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "skill"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_skill_id"
    t.string "name"
    t.string "email"
    t.integer "exp", default: 0
    t.string "password_digest"
    t.string "activation_digest"
    t.string "reset_digest"
    t.string "remember_digest"
    t.datetime "reset_sent_at"
    t.string "uid"
    t.string "provider"
    t.boolean "activated", default: false
    t.boolean "is_test_user", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "activated_at"
    t.integer "level", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_skill_id"], name: "index_users_on_user_skill_id"
  end

  create_table "word_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "word_definitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "word"
    t.json "dictionary_data"
    t.json "thesaurus_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["word"], name: "index_word_definitions_on_word", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "calendars", "users"
  add_foreign_key "consulted_words", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "cycles", "users"
  add_foreign_key "favorites", "learned_contents"
  add_foreign_key "favorites", "users"
  add_foreign_key "later_lists", "users"
  add_foreign_key "learn_templates", "users"
  add_foreign_key "learned_contents", "calendars"
  add_foreign_key "learned_contents", "users"
  add_foreign_key "learned_contents", "word_categories"
  add_foreign_key "learned_contents", "word_definitions"
  add_foreign_key "notifications", "users"
  add_foreign_key "questions", "learned_contents"
  add_foreign_key "related_images", "learned_contents"
  add_foreign_key "related_words", "learned_contents"
  add_foreign_key "related_words", "word_definitions"
  add_foreign_key "review_histories", "calendars"
  add_foreign_key "review_histories", "learned_contents"
  add_foreign_key "users", "user_skills"
end
