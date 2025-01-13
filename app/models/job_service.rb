# app/models/job_service.rb
class JobService < ApplicationRecord
  belongs_to :job
  belongs_to :service

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end