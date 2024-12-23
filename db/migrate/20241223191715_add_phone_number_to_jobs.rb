class AddPhoneNumberToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :phone_number, :string
  end
end
