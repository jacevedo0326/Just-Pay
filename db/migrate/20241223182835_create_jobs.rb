class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :customer_name
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
