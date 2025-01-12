class AddTracking < ActiveRecord::Migration[8.0]
  def change
    add_reference :jobs, :company_owner, null: true, foreign_key: { to_table: :users }
  end
end