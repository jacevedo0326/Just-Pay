class SetDefaultValuesForUsers < ActiveRecord::Migration[8.0]
  def up
    # Set default role for existing users
    execute <<-SQL
      UPDATE users 
      SET role = 'company_owner' 
      WHERE role IS NULL OR role NOT IN ('company_owner', 'worker');
    SQL
  end

  def down
    # This migration is irreversible
  end
end