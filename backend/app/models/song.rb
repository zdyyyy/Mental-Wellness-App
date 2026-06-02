class Song < ApplicationRecord
  belongs_to :genre

  validates :title, :url, presence: true
end
