class AddAddressToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :address, :string
  end
end
