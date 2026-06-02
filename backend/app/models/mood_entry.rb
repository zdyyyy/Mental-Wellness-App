class MoodEntry < ApplicationRecord
  belongs_to :user

  SOURCES = %w[DIARY CHAT].freeze

  validates :mood, :source, :recorded_at, presence: true
  validates :source, inclusion: { in: SOURCES }

  before_validation :set_recorded_at, on: :create

  private

  def set_recorded_at
    self.recorded_at ||= Time.current
  end
end
