class AddUserToServices < ActiveRecord::Migration[7.0]
  def change
    # First add the column allowing null
    add_reference :services, :user, null: true, foreign_key: true

    # Assign existing services to admin
    reversible do |dir|
      dir.up do
        admin = User.first || User.create!(
          email: 'admin@example.com',
          password: 'password123',
          role: 'admin'
        )

        # Assign all existing services to the admin user
        Service.update_all(user_id: admin.id)
      end
    end

    # Now make it non-null
    change_column_null :services, :user_id, false
  end
end