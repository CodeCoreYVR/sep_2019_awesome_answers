class CreateQuestions < ActiveRecord::Migration[6.0]

  # To run all your remaining migrations do:
  # rails db:migrate

  # To reverse the last migration:
  # rails db:rollback

  # To look at the status of migrations (whether they're active or not) use:
  # rails db:migrate:status

  def change
    create_table :questions do |t|
      t.string :title # This creates a VARCHAR(255) column named title
      t.text :body # This creates a TEXT column named body

      t.timestamps
      # This will create two columns "created_at"
      # and "updated_at" which will auto-update
    end
  end
end
