class RemoveLikeCountToQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_column :questions, :like_count, :integer
  end
end
