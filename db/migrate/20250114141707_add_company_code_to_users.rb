class AddCompanyCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :company_code, :string
    add_index :users, :company_code, unique: true
  end
end