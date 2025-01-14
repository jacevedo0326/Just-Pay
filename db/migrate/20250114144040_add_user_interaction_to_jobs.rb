class AddUserInteractionToJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :added_by, foreign_key: { to_table: :users }
    add_column :jobs, :last_modified_by_id, :integer
    add_foreign_key :jobs, :users, column: :last_modified_by_id
  end
end