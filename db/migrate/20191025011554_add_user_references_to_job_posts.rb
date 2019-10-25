class AddUserReferencesToJobPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :job_posts, :user, null: false, foreign_key: true
  end
end
