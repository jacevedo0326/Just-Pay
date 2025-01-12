# app/models/job.rb
class Job < ApplicationRecord
  belongs_to :user  # The worker who created the job
  belongs_to :company_owner, class_name: 'User'
  has_many :job_services, dependent: :destroy
  has_many :services, through: :job_services

  validates :customer_name, presence: true
  validates :date, presence: true
  validates :status, presence: true
  validates :user, presence: true

  before_validation :set_company_owner, on: :create

  def total_price
    job_services.sum { |job_service| job_service.quantity * job_service.service.price }
  end

  private

  def set_company_owner
    return unless user.present?
    self.company_owner = user.company_owner? ? user : user.company_owner
  end
end