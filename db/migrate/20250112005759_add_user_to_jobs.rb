class AddUserToJobs < ActiveRecord::Migration[7.0]
  def change
    # First add the column allowing null
    add_reference :jobs, :user, null: true, foreign_key: true

    # Create a default admin user if none exists
    reversible do |dir|
      dir.up do
        admin = User.create!(
          email: 'admin@example.com',
          password: 'password123',
          role: 'admin'
        )

        # Assign all existing jobs to the admin user
        Job.update_all(user_id: admin.id)
      end
    end

    # Now make it non-null
    change_column_null :jobs, :user_id, false
  end
end