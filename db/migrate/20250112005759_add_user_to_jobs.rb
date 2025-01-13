class AddUserToJobs < ActiveRecord::Migration[7.0]
  def change
    # First add both reference columns allowing null
    add_reference :jobs, :user, null: true, foreign_key: true
    add_reference :jobs, :company_owner, null: true, foreign_key: { to_table: :users }

    # Create a default company owner if none exists
    reversible do |dir|
      dir.up do
        company_owner = User.create!(
          email: 'admin@example.com',
          password: 'password123',
          role: 'company_owner'
        )

        # Now we can safely update both columns
        Job.update_all(user_id: company_owner.id, company_owner_id: company_owner.id)
      end
    end

    # Make both columns non-null
    change_column_null :jobs, :user_id, false
    change_column_null :jobs, :company_owner_id, false
  end
end