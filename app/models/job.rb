class Job < ApplicationRecord
  has_many :job_services, dependent: :destroy
  has_many :services, through: :job_services

  validates :customer_name, presence: true
  validates :date, presence: true
  validates :status, presence: true

  def total_price
    job_services.sum { |job_service| job_service.service.price * job_service.quantity }
  end
end