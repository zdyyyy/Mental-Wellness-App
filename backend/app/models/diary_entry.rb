class DiaryEntry < ApplicationRecord
  belongs_to :user

  validates :entry_date, presence: true, uniqueness: { scope: :user_id }
end
