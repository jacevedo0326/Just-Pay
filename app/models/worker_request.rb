class WorkerRequest < ApplicationRecord
  belongs_to :worker, class_name: 'User'
  belongs_to :company_owner, class_name: 'User'

  validates :status, inclusion: { in: %w[pending accepted rejected] }
  validates :worker_id, uniqueness: { scope: :company_owner_id }

  scope :pending, -> { where(status: 'pending') }
end