class AddCompanyRelationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :company_owner, null: true, foreign_key: { to_table: :users }
  end
end