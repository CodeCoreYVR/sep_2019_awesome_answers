class AddLikeCountToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :like_count, :integer
  end
end
