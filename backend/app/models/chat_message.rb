class ChatMessage < ApplicationRecord
  belongs_to :user

  ROLES = %w[USER ASSISTANT].freeze

  validates :role, :content, presence: true
  validates :role, inclusion: { in: ROLES }

  before_validation :set_created_at, on: :create

  private

  def set_created_at
    self.created_at ||= Time.current
  end
end
