class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: {
                            scope: :user_id,
                            message: "has already been liked"
                          }
end
