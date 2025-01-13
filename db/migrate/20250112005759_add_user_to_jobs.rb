class AddUserToJobs < ActiveRecord::Migration[7.0]
  def change
    # First add the column allowing null
    add_reference :jobs, :user, null: true, foreign_key: true

    # Create a default company owner if none exists
    reversible do |dir|
      dir.up do
        company_owner = User.create!(
          email: 'admin@example.com',
          password: 'password123',
          role: 'company_owner'  # Changed from 'admin' to 'company_owner'
        )

        # Assign all existing jobs to the company owner
        Job.update_all(user_id: company_owner.id, company_owner_id: company_owner.id)  # Added company_owner_id
      end
    end

    # Now make it non-null
    change_column_null :jobs, :user_id, false
  end
end