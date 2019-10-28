class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # Don't let the same user like the same question more than once.
  validates :question_id, uniqueness: {
                            scope: :user_id,
                            message: "has already been liked"
                          }
end
