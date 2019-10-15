class AddViewCountToQuestions < ActiveRecord::Migration[6.0]
  def change
    # Use add_column method to add columns to a table.
    # It's argyments are (in order):
    # - The table's name as a symbol
    # - The new column as a symbol
    # - The type of the new coumn
    add_column :questions, :view_count, :integer
  end
end
