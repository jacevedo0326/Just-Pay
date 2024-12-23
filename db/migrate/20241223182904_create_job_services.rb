class CreateJobServices < ActiveRecord::Migration[8.0]
  def change
    create_table :job_services do |t|
      t.references :job, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
