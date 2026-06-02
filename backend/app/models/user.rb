class User < ApplicationRecord
  has_secure_password

  has_many :diary_entries, dependent: :destroy
  has_many :mood_entries, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
