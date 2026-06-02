class CreateMindliftSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mood
      t.timestamps
    end
    add_index :users, :username, unique: true

    create_table :genres do |t|
      t.string :name, null: false
      t.string :cover_url
      t.timestamps
    end

    create_table :songs do |t|
      t.string :title, null: false
      t.string :artist
      t.references :genre, null: false, foreign_key: true
      t.string :url, null: false
      t.string :cover_url
      t.timestamps
    end

    create_table :diary_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date, null: false
      t.text :content, null: false, default: ""
      t.timestamps
    end
    add_index :diary_entries, %i[user_id entry_date], unique: true

    create_table :mood_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :mood, null: false, limit: 16
      t.string :source, null: false, limit: 16
      t.datetime :recorded_at, null: false
      t.timestamps
    end
    add_index :mood_entries, %i[user_id recorded_at]

    create_table :chat_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false, limit: 16
      t.text :content, null: false
      t.datetime :created_at, null: false
    end
    add_index :chat_messages, %i[user_id created_at]