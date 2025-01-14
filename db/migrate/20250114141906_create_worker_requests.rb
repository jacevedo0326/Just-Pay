class CreateWorkerRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :worker_requests do |t|
      t.references :worker, foreign_key: { to_table: :users }
      t.references :company_owner, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end