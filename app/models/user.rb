class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company_owner, class_name: 'User', optional: true
  has_many :workers, class_name: 'User', foreign_key: 'company_owner_id'
  has_many :jobs
  has_many :services

  ROLES = %w[company_owner worker].freeze

  validates :company_owner, presence: true, unless: :company_owner?
  validates :role, inclusion: { in: ROLES }

  def company_owner?
    role == 'company_owner'
  end

  def worker?
    role == 'worker'
  end

  # Get all jobs accessible to this user
  def accessible_jobs
    if company_owner?
      Job.where(company_owner_id: id)
    else
      Job.where(company_owner_id: company_owner_id)
    end
  end

  # Get all services accessible to this user
  def accessible_services
    if company_owner?
      services
    else
      company_owner.present? ? company_owner.services : Service.none
    end
  end
end